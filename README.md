# 颜值素人主播获奖查询

静态前端页面，使用 Appwrite TablesDB 作为查询数据源。

## Appwrite 配置说明

本项目使用快手内部定制版 Appwrite CLI（`appwrite-cf`）进行资源管理。

> ⚠️ 严禁使用官方 `appwrite` 命令，必须使用 `appwrite-cf`。
> 官方 CLI 无法连接快手内部 Appwrite 实例，误用将导致错误或操作到错误环境。

- 项目 ID：`yanzhisurenrewards`
- Database：`rewardsdb`
- Table：`anchor_rewards`
