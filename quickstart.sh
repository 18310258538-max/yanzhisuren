#!/bin/bash
# quickstart.sh - 一键完成所有配置
# 用法：./quickstart.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║      颜值素人主播获奖查询系统 - 快速配置向导              ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${YELLOW}本脚本将帮你完成：${NC}"
echo "  ✓ 检查并安装Python依赖"
echo "  ✓ 配置Git和GitHub"
echo "  ✓ 完成首次部署"
echo "  ✓ 验证整个流程"
echo ""

read -p "准备开始？(y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}已取消${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  第一步：安装依赖${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

./install_dependencies.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 依赖安装失败，请检查错误信息${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  第二步：初始化Git仓库${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

./init_repo.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Git初始化失败${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  第三步：测试更新流程${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

# 找到最新的Excel文件
LATEST_EXCEL=$(ls -t *.xlsx 2>/dev/null | head -1)

if [ -z "$LATEST_EXCEL" ]; then
    echo -e "${YELLOW}⚠️  未找到Excel文件，跳过测试更新${NC}"
else
    echo -e "${YELLOW}找到Excel文件：$LATEST_EXCEL${NC}"
    read -p "是否使用此文件进行测试更新？(y/n) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ./update_site.sh "$LATEST_EXCEL"
    else
        echo -e "${YELLOW}跳过测试更新${NC}"
    fi
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}  🎉 配置完成！${NC}"
echo -e "${GREEN}═══════════════════════════════════════${NC}"
echo ""

# 提取GitHub用户名（从git remote）
GITHUB_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [[ $GITHUB_URL =~ github\.com[:/]([^/]+)/yanzhisuren ]]; then
    GITHUB_USERNAME="${BASH_REMATCH[1]}"
    
    echo -e "${CYAN}📍 接下来的操作：${NC}"
    echo ""
    echo -e "${YELLOW}1. 配置GitHub Pages${NC}"
    echo -e "   访问: ${BLUE}https://github.com/$GITHUB_USERNAME/yanzhisuren/settings/pages${NC}"
    echo "   设置："
    echo "   - Source: Deploy from a branch"
    echo "   - Branch: main"
    echo "   - Folder: /public-site"
    echo "   - 点击 Save"
    echo ""
    echo -e "${YELLOW}2. 等待1-2分钟后访问${NC}"
    echo -e "   ${BLUE}https://$GITHUB_USERNAME.github.io/yanzhisuren/${NC}"
    echo ""
    echo -e "${YELLOW}3. 日常更新命令${NC}"
    echo "   ./update_site.sh \"新的Excel文件.xlsx\""
    echo ""
fi

echo -e "${CYAN}📚 更多帮助请查看：${NC}"
echo "   - README.md (项目说明)"
echo "   - setup_guide.md (详细配置指南)"
echo ""
