# 颜值素人奖励公示系统 - 环境配置指南

## 📋 配置检查清单

### 1. ✅ Git（已完成）
- 版本：2.53.0
- 状态：已安装

### 2. ⏳ Python 3（待完成）
**当前状态**：需要先安装 Xcode Command Line Tools

**操作步骤**：
1. 系统应该已弹出安装窗口，点击「安装」
2. 如未弹出，在终端执行：`xcode-select --install`
3. 等待5-10分钟完成安装
4. 验证安装：`python3 --version`

---

## 🔑 GitHub 配置步骤

### 准备信息
根据你的描述，请准备以下信息：
- **GitHub 账号**：[你的GitHub用户名]
- **仓库地址**：https://github.com/[你的账号]/yanzhisuren
- **PAT Token**：[你刚才保存的 Token]

### 配置步骤

#### Step 1: 初始化本地Git仓库
```bash
cd "/Users/zhangzhiyu10/Desktop/六月颜值素人报名火花配置 - automated"
git init
git config user.name "你的名字"
git config user.email "你的邮箱"
```

#### Step 2: 配置GitHub远程仓库
```bash
# 添加远程仓库（请替换 [你的账号] 为实际的GitHub用户名）
git remote add origin https://github.com/[你的账号]/yanzhisuren.git

# 验证远程仓库
git remote -v
```

#### Step 3: 配置 PAT Token 认证
```bash
# 配置 credential helper（macOS使用keychain）
git config --global credential.helper osxkeychain

# 首次推送时会要求输入用户名和密码
# 用户名：你的GitHub用户名
# 密码：粘贴你的 PAT Token（不是GitHub密码！）
```

#### Step 4: 创建 .gitignore
```bash
# 创建 .gitignore 文件，排除不需要上传的文件
cat > .gitignore << 'EOF'
.DS_Store
*.xlsx
__pycache__/
*.pyc
.vscode/
.idea/
EOF
```

#### Step 5: 首次提交和推送
```bash
# 添加所有文件
git add .

# 创建首次提交
git commit -m "初始化颜值素人奖励公示系统"

# 推送到GitHub（首次推送会要求输入PAT）
git branch -M main
git push -u origin main
```

---

## 🚀 GitHub Pages 配置

1. 进入你的仓库：`https://github.com/[你的账号]/yanzhisuren`
2. 点击 **Settings** → 左侧菜单 **Pages**
3. **Source** 选择：`Deploy from a branch`
4. **Branch** 选择：`main` 分支，目录选择 `/public-site`
5. 点击 **Save**
6. 等待1-2分钟，访问：`https://[你的账号].github.io/yanzhisuren/`

---

## 📝 日常更新流程

当你收到新的Excel文件（如：`7.14颜值素人奖励公示名单表.xlsx`）时：

### 方式一：使用自动化脚本（推荐）
```bash
# 运行更新脚本
./update_site.sh "7.14颜值素人奖励公示名单表.xlsx"
```

### 方式二：手动执行
```bash
# 1. 将新的Excel文件放到项目根目录
# 2. 转换Excel为JSON（需要先安装依赖）
python3 convert_excel_to_json.py "7.14颜值素人奖励公示名单表.xlsx"

# 3. 生成新的HTML
cd public-site
python3 generate_site.py

# 4. 提交并推送
cd ..
git add .
git commit -m "更新7.14日奖励公示数据"
git push
```

---

## 🎯 下一步操作

完成 Xcode Command Line Tools 安装后，我将帮你：
1. ✅ 验证Python环境
2. ✅ 安装Python依赖（openpyxl）
3. ✅ 初始化Git仓库并配置GitHub
4. ✅ 创建自动化更新脚本
5. ✅ 执行一次完整的测试更新

**请在Xcode Command Line Tools安装完成后告诉我！**
