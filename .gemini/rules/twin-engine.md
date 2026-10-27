# 双星智能体协同规则 (Twin-Engine Orchestration Rules)

在本项目（`aam`）及相关开发任务中，开启并遵循 **“双星智能体协同 (Twin-Engine Orchestration)”** 工作机制：

## 1. 角色分工 (Roles & Responsibilities)
- **执行工程师与全局管家 (Hands & Executor)**：
  - **主体**：当前会话主智能体（官方 Gemini 3.8 Flash / 原生引擎）。
  - **职责**：持有 Antigravity 原生全套系统工具权限（`read_file`、`write_file`、`edit_file`、`run_command`、`browser`、`invoke_subagent` 等）。
  - **任务**：负责全局上下文扫描、代码读写、终端测试执行、本地环境验证、跨模型调用调度与最终结果汇总。
- **架构总师与深度智囊 (Brain & Architect)**：
  - **主体**：通过 `api-model-switcher-mcp` 调用的第三方中转高级模型（如 Claude 3.7 Thinking / GPT-4o / gpt 6 astra）。
  - **职责**：负责顶层方案架构设计、复杂算法逻辑推演、疑难并发/竞态 Bug 根因剖析以及代码终审审查（Code Review）。

## 2. 自动协同触发机制 (Trigger Conditions)
遇到以下情形之一时，主智能体应**主动发起双星协同**，向中转高级模型请教：
1. **复杂架构设计与方案重构**：如核心通信协议设计、多模块状态同步机制设计；
2. **疑难 Bug 深度排查**：连续尝试未能根治的死锁、竞态、流式截断或状态脱节问题；
3. **用户明确指示**：用户提问中包含 `@architect`、`@thinker`，或明确提到“请向 Claude/高级模型咨询方案”时；
4. **官方高级模型配额为 0% 且需要高阶逻辑推演时**：自动向中转模型借力。

## 3. 标准协作流转协议 (Workflow Protocol)
1. **收集与提炼**：主智能体快速通过原生工具读取关键代码与报错日志，提炼出精简的上下文与核心问题；
2. **智囊咨询**：主智能体调用 `call_mcp_tool(ServerName: "api-model-switcher_api-model-switcher-mcp", ToolName: "chat_with_custom_model", Arguments: { prompt: "..." })` 获取中转高级模型的推演思路与代码建议；
3. **原生工具落地**：主智能体接管中转模型的方案，使用原生的 `edit_file`（生成可视化 Diff 补丁）修改文件，并使用 `run_command` 在终端执行测试或验证；
4. **统一闭环汇报**：测试通过后，主智能体在主会话窗口汇总呈现修改结果与架构思路。
