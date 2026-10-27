# 蓝图压缩与门控实战对比 (Blueprint & Gating Case Study)

本篇演示优化前后的真实对比数据。

---

## 一、自适应门控拦截对比（节流实测）

### 场景：用户提问“帮我给 UserDTO 加一个 phone 字段并在单元测试里补全 mock”
* **优化前**：错误唤醒 Claude 3.7 Thinking，消耗 4,200 Token，等待 18 秒；
* **优化后**：命中 Level 2 快速阻断特征（单测与字段补全），由本地轻量执行手（Gemini Flash）直接在 1.2 秒内修改并跑测，**API 消耗为 0，节省费用 100%**。

---

## 二、蓝图协议 vs 整文件重写对比（压缩实测）

### 场景：重构高并发订单分布式锁机制

#### 优化前（全量代码返回）
* 架构脑打印了整整 480 行完整 TypeScript 代码；
* 消耗 Output Token：~4,500 Tokens；
* 耗时：32 秒；
* 风险：第 230 行处模型因长度超限自动略过了原有 80 行辅助函数，导致本地补丁编译失败。

#### 优化后（遵循 Blueprint Protocol）
* 架构脑仅返回精炼蓝图：
  ```markdown
  - [TARGET]: OrderService.processPayment
  - [RATIONALE]: 引入 Redis Redlock 与数据库版本号双重防重，消除扣款窗口期的竞态。
  - [BLUEPRINT]:
    async function processPaymentWithLock(orderId: string, version: number) {
      const lock = await redlock.acquire([`lock:order:${orderId}`], 3000);
      try {
        const rows = await db.orders.update({ version: version + 1 })
          .where({ id: orderId, version });
        if (rows === 0) throw new ConcurrencyConflictError("Order modified concurrently");
        return await gateway.charge(orderId);
      } finally {
        await lock.release();
      }
    }
  - [EDGE_CASES]:
    1. Lock 续期机制（Heartbeat）避免重度支付网络延迟导致锁提前释放；
    2. ConcurrencyConflictError 向上抛出触发客户端指数退避重试。
  ```
* 消耗 Output Token：仅 **380 Tokens（削减 91.5%）**；
* 耗时：**4.1 秒（速度提升 7.8 倍）**；
* 本地执行手依据该蓝图精准将函数内嵌并跑测通过。
