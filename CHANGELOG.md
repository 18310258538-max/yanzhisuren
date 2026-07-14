# Changelog — 颜值素人主播获奖查询系统

---

## [1.3.0] - 2026-06-15

### 数据更新
- 从 `6.15最终颜值素人奖励公示名单表.xlsx` 读取最新奖励总表
- 有效数据 896 条（含 20260615 新增 267 条 · 八万曝光小火苗 · 返点活动奖励流量）
- 外网页面更新时间：2026-06-15 23:39

### Bug 修复
- 修复快手ID为空时存储为数字 `0` 的问题，改为存空字符串
- 修复前端查询：输入纯数字时不再走 ks_id 查询，防止命中所有空快手ID主播

### 架构变更
- 前端从"调用内网 Appwrite API"改为"数据直接嵌入 HTML"
  - 不再依赖快手内网 Appwrite（`frontend-cloud.corp.kuaishou.com`）
  - 单文件 HTML，无后端依赖，外网可直接访问
- 外网部署平台由无改为 **GitHub Pages**

### 新增功能
- 外网查询地址正式上线：`https://onecooldevil.github.io/yanzhisuren/`
- 新增 `generate_site.py`：从 JSON 数据一键生成嵌入数据的 HTML 文件
- 配置每日 14:00 定时任务（CodeFlicker Scheduled Tasks）：
  - 读取青雀文档奖励总表
  - 重新生成 `index.html`
  - 自动 git push 到 GitHub Pages
- GitHub PAT 已写入本地 credential store，后续推送无需手动认证

---

## [1.2.0] - 2026-06-15

### 新增功能
- 接入快手内部 Appwrite TablesDB 作为数据后端，替代代码内嵌数据
  - 数据库：`rewardsdb` / 表：`anchor_rewards`
  - 项目 ID：`yanzhisurenrewards`
- 完整导入 629 条历史获奖数据（来源：`anchor_data_new.json`，截至 20260612）
- 数据行公开读权限：`read("any")`

### 改动
- 前端查询逻辑改为从 Appwrite REST API 查询，去掉内嵌 `DATA` 变量
- 查询参数格式改为 JSON query object（`{"method":"equal","attribute":...}`）

### Bug 修复
- 修复 `create-string-column` 命令不支持 `--name` 参数的问题
- 修复源数据 JSON key 为中文列名（非英文），导入时字段全为空的问题
- 修复前端 query DSL 格式错误导致 400 Bad Request 的问题
- 修复查询值被 `toLowerCase()` 处理导致快手号大小写不匹配的问题

---

## [1.1.0] - 2026-06-15

### UI 改进
- 查询按钮移至输入框下方，改为全宽，优化手机端操作体验
- 新增显示"获奖时间"（原"奖励填入时间"字段）
- "配置状态"改为"是否配置"，更易理解
- 提示文案中的真实主播 ID 替换为虚构示例（`123456789` / `kuaishouuser01`）

### 部署
- 内网地址部署：`https://ks-anchor-reward-query.frontend-cloud.corp.kuaishou.com`

---

## [1.0.0] - 2026-06-15

### 初始版本
- 静态 H5 查询页面，支持按主播数字 ID 或快手号查询
- 获奖数据直接内嵌于 HTML JS 变量
- 移动端适配，橙色品牌风格 UI
- 多条奖励按获奖时间倒序排列展示
