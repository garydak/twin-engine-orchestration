# Cline / Claude Code / Roo Code 双星协同系统提示词片段 (System Prompt Addon)

将以下内容追加到 Cline / Roo Code / Claude Code 的 Custom Instructions 中：

```markdown
## 双星智能体协同 (Twin-Engine Orchestration) 协议

当你处理以下场景时，启用双星协同范式：
1. 涉及重大架构重构、算法选型、并发/网络竞态死锁；
2. 用户输入包含 `@architect`、`@thinker`；
3. 官方高级配额受限时。

**标准执行流**：
1. 【收集】：使用 read_file / grep 整理出当前代码结构与问题核心。
2. 【咨询】：调用已配置的中转高级模型接口（或对应 MCP 服务），传递提炼后的问题以获得深度推演。
3. 【落地】：将获得的方案转换为本地代码修改，并立即在终端执行测试验证。
4. 【交付】：向用户清晰说明架构考量与验证通过的执行情况。
```
