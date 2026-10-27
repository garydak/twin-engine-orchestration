# 双星协同实战全流程示例 (Sample Workflow Walkthrough)

本示例展示在电商支付结算系统改造中，双星智能体如何全自动完成协同闭环：

---

### Step 1: 触发任务
用户在会话中输入：
> *“@architect 我们下单支付模块在高并发时有用户反馈订单偶发重复扣款，请帮我彻底排查并重构状态转移逻辑，完成本地验证。”*

---

### Step 2: 主智能体（执行手）定位与精简上下文
主智能体使用原生 `read_file` 查阅 `src/payment/order-service.ts`，定位到状态判断与扣款调用的时间窗口漏洞，提取核心方法与类型定义。

---

### Step 3: 唤醒架构脑（中转高级模型推演）
主智能体通过 `chat_with_custom_model` 工具向中转站高级模型（如 Claude 3.7 Sonnet 或 o1）发送结构化咨询请求：
```
【任务类型】：并发排错与重构
【背景】：订单扣款存在并发时序差，无乐观锁或分布式锁保护。
【核心代码】：...
【期待】：提供防重幂等设计与状态机转移实现。
```

架构脑返回：
1. **分析**：指出缺少数据库版本号乐观锁（Optimistic Locking）及分布式锁双重防御；
2. **方案**：提供带版本比对的 CAS 更新状态机代码片段与幂等 Token 校验流程。

---

### Step 4: 主智能体原生落地与验证
1. **自动打补丁**：主智能体使用 `edit_file`，将架构脑给出的 `updateOrderStatusWithCas` 方法优雅应用到 `src/payment/order-service.ts` 中。
2. **本地测试执行**：主智能体调用 `run_command` 执行并发单测：
   ```bash
   npm test -- tests/payment-concurrency.test.ts
   ```
3. **输出结果**：1000 组并发请求测试全量通过，无重复扣款发生。

---

### Step 5: 向用户透明交付
主智能体向用户汇报：
- **架构脑分析结论**：根因为缺少并发幂等 CAS 控制；
- **落地文件**：[`order-service.ts`](file:///src/payment/order-service.ts) 已完成改造；
- **自动化测试结果**：单元测试 100% 通过。
