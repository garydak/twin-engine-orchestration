# 架构脑大模型配置与管理指南 (Architect Brain Setup Guide)

本文档详细说明如何为 **Twin-Engine Orchestration (双星智能体协作)** 框架配置、管理并切换“架构脑”（顶级推理模型）。

---

## 一、架构脑推荐模型选型

双星协同的核心是将“高难度深度推演”与“本地工具落地”解耦。因此，架构脑推荐选用具有强推理能力（Reasoning / Thinking）的旗舰模型：

| 模型分类 | 推荐模型标识符 (Model ID) | 特长与适用场景 |
| :--- | :--- | :--- |
| **Anthropic 系列** | `claude-sonnet-5-5`<br>`claude-opus-5-5` | 复杂系统架构重构、领域建模、状态机设计、深层逻辑推演 |
| **OpenAI / 演进系列** | `gpt-6-astra`<br>`gpt-6.1-sol`<br>`o1` | 复杂算法推导、数学建模、高并发锁冲突时序分析 |
| **开源推理旗舰** | `deepseek-reasoner` (DeepSeek R1) | 性价比极高的长思考链模型，深度代码审查与逻辑严密排查 |

---

## 二、配置方式详解

框架提供了三种配置架构脑的方式，满足不同开发习惯：

### 方式 1：对话一键配置（最直观快捷）

在任意对话窗口中，直接以自然语言将中转站信息发送给智能体：

> **开发者指令示例**：  
> *“帮我配置一个架构脑模型：*  
> *名称：`Claude 5.5 Sonnet`*  
> *BaseURL：`https://api.your-relay.com/v1`*  
> *API Key：`sk-xxxxxxxxxxxxxxxx`*  
> *Model ID：`claude-sonnet-5-5`*  
> *协议：`auto`，并设为当前激活的架构脑。”*

智能体将自动调用底层的 `add_custom_model` 工具完成：
1. 凭据加密与保存；
2. 自动发起网络握手与连通性测速；
3. 将其设置为当前默认调用的架构脑。

---

### 方式 2：搭配 `antigravity-api-manager` 可视化面板管理（推荐）

搭配配套项目 [**Antigravity API Manager**](https://github.com/garydak/antigravity-api-manager) 时，可直接使用原生侧边栏面板管理：

1. 打开 Antigravity 右侧控制台面板；
2. 进入 **“中转模型管理”** 页面；
3. 点击 **“添加模型”**，填入你的中转站地址与 Key；
4. 点击 **“连接测试”**，即可查看实时响应延迟（ms）与输出状态；
5. 点击模型右侧的 **“激活”** 按钮，一键设为全局默认架构脑。

---

### 方式 3：直接编辑配置文件 (`models.json`)

在底层存储目录中，配置以 JSON 格式存储：

```json
[
  {
    "id": "mdl_claude_55_sonnet",
    "name": "Claude 5.5 Sonnet (Thinking)",
    "modelId": "claude-sonnet-5-5",
    "baseUrl": "https://api.your-relay.com/v1",
    "apiKey": "sk-your-relay-api-key",
    "protocol": "openai",
    "maxTokens": 16384,
    "temperature": 0.7,
    "reasoningEffort": "high"
  },
  {
    "id": "mdl_gpt_6_astra",
    "name": "GPT 6 Astra (Deep Think)",
    "modelId": "gpt-6-astra",
    "baseUrl": "https://api.your-relay.com/v1",
    "apiKey": "sk-your-relay-api-key",
    "protocol": "openai",
    "maxTokens": 16384,
    "temperature": 0.8,
    "reasoningEffort": "high"
  }
]
```

---

## 三、核心配置参数详解

| 参数项 | 类型 | 说明与注意事项 |
| :--- | :---: | :--- |
| **`name`** | string | 显示名称，支持中英文，如 `Claude 5.5 Sonnet` |
| **`modelId`** | string | **核心参数**。中转站实际转发给上游的模型 ID（必须与你的中转站可用模型列表完全一致） |
| **`baseUrl`** | string | 中转站根地址。标准 OpenAI 规范通常以 `/v1` 结尾（如 `https://api.moremark.app/v1`） |
| **`apiKey`** | string | 鉴权令牌。系统在本地安全脱敏存储，仅展示掩码（如 `sk-7c8••••3034`） |
| **`protocol`** | enum | 支持 `auto`（推荐）、`openai`（兼容 /chat/completions）、`anthropic`（兼容 /messages） |
| **`reasoningEffort`** | string | 思考深度。可选 `low` / `medium` / `high` / `max`，控制 Thinking 模型的思考 Token 预算 |

---

## 四、日常调用与动态切换

架构脑支持**双层调用机制**，无需每次都重新配置：

### 1. 全局默认激活模式
系统日常在遇到高复杂度（评分 ≥ 6）任务时，会自动调用当前已激活的默认模型。  
想要更换默认模型时，只需输入：
> *“把默认架构脑切换为 `gpt-6-astra`”*

### 2. 单次提问动态覆盖（无需改配置）
针对不同专业领域的任务，你可以在指令中实时指定想要使用的特定模型：

* **算法难题**：`@architect [gpt-6-astra] 请分析这道大规模图遍历算法的内存瓶颈`
* **系统重构**：`@architect [claude-sonnet-5-5] 请设计分布式订单状态机`
* **极致推演**：`@architect [claude-opus-5-5] 请深度审查这里的并发竞态与死锁风险`

底层将根据方括号内的标识符动态路由到目标模型，并在本次任务完成后自动归位。
