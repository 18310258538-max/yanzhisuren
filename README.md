# 颜值素人主播获奖查询系统

快手颜值素人主播可以通过此网页查询自己的获奖记录。

## 🌐 访问地址

外网查询地址：`https://[你的GitHub账号].github.io/yanzhisuren/`

## 📦 项目结构

```
.
├── data/
│   └── anchor_data_latest.json      # 最新奖励数据（JSON格式）
├── public-site/
│   ├── generate_site.py             # HTML生成脚本
│   ├── index.html                   # 查询页面（包含嵌入数据）
│   └── README.md
├── convert_excel_to_json.py         # Excel转JSON脚本
├── update_site.sh                   # 一键更新脚本（推荐使用）
├── init_repo.sh                     # 仓库初始化脚本
├── setup_guide.md                   # 详细配置指南
└── CHANGELOG.md                     # 变更日志
```

## 🚀 快速开始

### 首次配置（仅需一次）

1. **安装依赖**
```bash
# 确保Python 3已安装
python3 --version

# 安装Excel处理库
pip3 install openpyxl
```

2. **初始化GitHub仓库**
```bash
./init_repo.sh
```
按照向导输入你的GitHub信息和PAT Token。

3. **配置GitHub Pages**
- 访问 `https://github.com/[你的账号]/yanzhisuren/settings/pages`
- Source: `Deploy from a branch`
- Branch: `main` / Folder: `/public-site`
- 点击 Save

### 日常更新流程

当收到新的Excel文件时（如：`7.14颜值素人奖励公示名单表.xlsx`）：

**方式一：使用自动化脚本（推荐）**
```bash
./update_site.sh "7.14颜值素人奖励公示名单表.xlsx"
```

这个脚本会自动完成：
1. ✅ 转换Excel为JSON
2. ✅ 生成新的HTML页面
3. ✅ Git提交更改
4. ✅ 推送到GitHub

等待1-2分钟后，网页会自动更新。

**方式二：手动执行**
```bash
# 1. 转换Excel为JSON
python3 convert_excel_to_json.py "7.14颜值素人奖励公示名单表.xlsx"

# 2. 生成HTML
cd public-site
python3 generate_site.py
cd ..

# 3. 提交并推送
git add .
git commit -m "更新7.14日奖励公示数据"
git push
```

## 📋 数据格式说明

### Excel表格字段
- 主播ID
- 快手ID
- 主播昵称
- 奖励明细（小火苗/涨粉/流量券）
- 奖励原因（返点活动报名/入群备注奖励等）
- 奖励填入时间
- 预计生效时间
- 是否配置&配置人

### 查询功能
主播可以通过以下方式查询：
- **主播ID**（数字ID）
- **快手号**（字母账号）

## 🛠️ 技术栈

- **前端**：纯HTML+JavaScript（单文件，无依赖）
- **数据处理**：Python 3 + openpyxl
- **部署**：GitHub Pages（免费，稳定）
- **自动化**：Bash脚本

## ⚠️ 注意事项

1. **PAT Token权限**：需要 `repo` 权限
2. **Excel文件不会上传**：太大，只上传转换后的JSON
3. **首次推送**：需要输入PAT Token作为密码
4. **后续推送**：macOS会自动保存PAT到钥匙串

## 🆘 常见问题

### 推送失败？
- 检查网络连接
- 确认PAT Token权限包含 `repo`
- 确认仓库已在GitHub创建

### 页面不更新？
- 等待1-2分钟（GitHub Pages需要构建时间）
- 清除浏览器缓存
- 检查GitHub仓库是否有最新提交

### Python报错？
- 确认已安装：`pip3 install openpyxl`
- 确认Python版本：`python3 --version`（需要3.6+）

## 📞 联系方式

- 运营团队：颜值品类运营团队
- 数据更新：每日更新
- 问题反馈：联系运营人员

## 📜 更新日志

详见 [CHANGELOG.md](CHANGELOG.md)

---

**快手颜值品类运营团队** © 2026
