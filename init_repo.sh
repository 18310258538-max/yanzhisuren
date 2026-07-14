#!/bin/bash
# init_repo.sh - 初始化GitHub仓库配置脚本
# 用法：./init_repo.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  GitHub 仓库初始化向导${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 收集用户信息
read -p "请输入你的GitHub用户名: " GITHUB_USERNAME
read -p "请输入你的姓名（用于Git提交）: " GIT_NAME
read -p "请输入你的邮箱（用于Git提交）: " GIT_EMAIL
echo ""

echo -e "${YELLOW}📝 确认信息：${NC}"
echo -e "   GitHub用户名: ${BLUE}$GITHUB_USERNAME${NC}"
echo -e "   姓名: $GIT_NAME"
echo -e "   邮箱: $GIT_EMAIL"
echo -e "   仓库地址: ${BLUE}https://github.com/$GITHUB_USERNAME/yanzhisuren${NC}"
echo ""

read -p "信息正确吗？(y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}已取消${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}[1/5]${NC} 配置Git用户信息..."
git config user.name "$GIT_NAME"
git config user.email "$GIT_EMAIL"
git config --global credential.helper osxkeychain
echo -e "${GREEN}✅ Git配置完成${NC}"
echo ""

echo -e "${BLUE}[2/5]${NC} 初始化Git仓库..."
if [ ! -d .git ]; then
    git init
    echo -e "${GREEN}✅ Git仓库初始化完成${NC}"
else
    echo -e "${YELLOW}⚠️  Git仓库已存在，跳过${NC}"
fi
echo ""

echo -e "${BLUE}[3/5]${NC} 配置远程仓库..."
if git remote | grep -q '^origin$'; then
    echo -e "${YELLOW}⚠️  远程仓库已存在，更新地址${NC}"
    git remote set-url origin "https://github.com/$GITHUB_USERNAME/yanzhisuren.git"
else
    git remote add origin "https://github.com/$GITHUB_USERNAME/yanzhisuren.git"
fi
echo -e "${GREEN}✅ 远程仓库配置完成${NC}"
git remote -v
echo ""

echo -e "${BLUE}[4/5]${NC} 创建首次提交..."
git add .
git commit -m "初始化颜值素人奖励公示系统" || echo -e "${YELLOW}⚠️  已有提交，跳过${NC}"
echo ""

echo -e "${BLUE}[5/5]${NC} 推送到GitHub..."
echo -e "${YELLOW}⚠️  即将首次推送，请准备好你的 PAT Token${NC}"
echo -e "${YELLOW}   用户名输入：$GITHUB_USERNAME${NC}"
echo -e "${YELLOW}   密码输入：粘贴你的 PAT Token（不是GitHub密码！）${NC}"
echo ""
read -p "准备好了吗？按回车继续..." 

git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✅ 仓库初始化完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${YELLOW}📍 下一步操作：${NC}"
    echo "1. 访问 ${BLUE}https://github.com/$GITHUB_USERNAME/yanzhisuren/settings/pages${NC}"
    echo "2. 在 Pages 设置中："
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: main"
    echo "   - Folder: /public-site"
    echo "3. 点击 Save，等待1-2分钟"
    echo "4. 访问 ${BLUE}https://$GITHUB_USERNAME.github.io/yanzhisuren/${NC}"
    echo ""
else
    echo -e "${RED}❌ 推送失败${NC}"
    echo -e "${YELLOW}💡 可能的原因：${NC}"
    echo "   1. PAT Token 权限不足（需要 repo 权限）"
    echo "   2. 仓库不存在（请先在GitHub创建 yanzhisuren 仓库）"
    echo "   3. 网络连接问题"
    exit 1
fi
