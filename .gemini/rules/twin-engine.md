# 双星智能体协同规则 2.0 (Twin-Engine Orchestration Rules v2.0)

在本项目（`aam`）及相关开发任务中，开启并遵循 **“双星智能体协同 2.0”** 工作机制：

## 1. 角色分工 (Roles & Responsibilities)
- **执行工程师与全局管家 (Hands & Executor)**：
  - **主体**：当前会话主智能体（官方 Gemini 3.8 Flash / 原生引擎）。
  - **职责**：持有全套原生系统工具（`read_file`、`write_file`、`edit_file`、`run_command` 等），负责自适应路由门控，提炼上下文，将架构蓝图转换为本地精准 Diff 补丁并跑测验证。
- **架构总师与深度智囊 (Brain & Architect)**：
  - **主体**：通过 `api-model-switcher-mcp` 调用的第三方中转顶级模型（如 Claude 5.5 Sonnet / Opus Thinking / GPT 6 Astra / DeepSeek R1）。
  - **职责**：负责顶层方案架构设计、复杂算法逻辑推演、疑难并发/竞态 Bug 根因剖析，遵循高密度蓝图协议输出核心决策（< 80行）。

## 2. 自适应路由门控触发机制 (Adaptive Gating)
1. **显式覆盖**：用户提问包含 `@architect`、`@thinker` 或指名咨询高级模型时，无条件唤醒架构脑；
2. **快速阻断**：常规单测、变量重命名、简单语法修正、CSS 样式调整等轻量任务，强制由执行手内部解决，**零 API 额外消耗**；
3. **复杂度雷达 (评分 ≥ 6)**：遇到高并发竞态、死锁、状态机重构、复杂算法瓶颈、安全审计或本地修复连续 2 次失败时，自动发起双星协同。

## 3. 高密度蓝图协议 (Blueprint Protocol)
- 架构脑输出严格受限：仅输出 `[TARGET]`、`[RATIONALE]`、`[BLUEPRINT]`（核心伪代码/实现，限 80 行内）及 `[EDGE_CASES]`，杜绝输出大段整文件代码；
- 本地执行手负责将蓝图映射回现有代码，生成严密增量 Diff 并执行本地测试套件。
