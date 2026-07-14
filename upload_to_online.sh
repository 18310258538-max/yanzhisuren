#!/bin/bash
# upload_to_online.sh - 上传奖励数据到线上GitHub Pages
# 用法：./upload_to_online.sh "7.14颜值素人奖励公示名单表.xlsx"

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║    颜值素人奖励公示系统 - 上传到线上GitHub Pages         ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# 检查参数
if [ -z "$1" ]; then
    echo -e "${RED}❌ 错误：请提供Excel文件路径${NC}"
    echo "用法：./upload_to_online.sh \"7.14颜值素人奖励公示名单表.xlsx\""
    exit 1
fi

EXCEL_FILE="$1"

# 检查文件是否存在
if [ ! -f "$EXCEL_FILE" ]; then
    echo -e "${RED}❌ 错误：文件不存在 - $EXCEL_FILE${NC}"
    exit 1
fi

# 提取日期
FILENAME=$(basename "$EXCEL_FILE")
DATE_STR=$(echo "$FILENAME" | grep -oE '[0-9]+\.[0-9]+' | head -1)
if [ -z "$DATE_STR" ]; then
    DATE_STR=$(date +%m.%d)
fi

echo -e "${YELLOW}📁 Excel文件：$EXCEL_FILE${NC}"
echo -e "${YELLOW}📅 更新日期：$DATE_STR${NC}"
echo ""

# 备份旧的JSON文件（用于对比）
if [ -f "data/anchor_data_latest.json" ]; then
    echo -e "${BLUE}[准备]${NC} 备份旧数据..."
    cp data/anchor_data_latest.json data/anchor_data_backup.json
    echo -e "${GREEN}✅ 已备份到 data/anchor_data_backup.json${NC}"
else
    echo -e "${YELLOW}⚠️  未找到旧数据文件，跳过备份${NC}"
fi
echo ""

# Step 1: 转换Excel为JSON
echo -e "${BLUE}[1/5]${NC} 转换Excel为JSON..."
python3 convert_excel_to_json.py "$EXCEL_FILE"
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Excel转JSON失败${NC}"
    exit 1
fi
echo ""

# Step 2: 对比数据变化
echo -e "${BLUE}[2/5]${NC} 对比数据变化..."
if [ -f "data/anchor_data_backup.json" ]; then
    COMPARE_OUTPUT=$(python3 compare_data.py data/anchor_data_backup.json data/anchor_data_latest.json)
    echo "$COMPARE_OUTPUT"
    
    # 提取提交信息
    COMMIT_MSG=$(echo "$COMPARE_OUTPUT" | grep "auto: daily update" | tail -1)
    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="auto: daily update $(date +%Y-%m-%d)"
    fi
else
    echo -e "${YELLOW}⚠️  无旧数据，无法对比${NC}"
    COMMIT_MSG="auto: daily update $(date +%Y-%m-%d)"
fi
echo ""

# Step 3: 生成新的HTML
echo -e "${BLUE}[3/5]${NC} 生成新的HTML页面..."

# 检查项目结构
if [ -d "public-site" ]; then
    echo -e "${YELLOW}检测到public-site目录结构${NC}"
    cd public-site
    python3 generate_site.py ../data/anchor_data_latest.json
    HTML_FILE="index.html"
    cd ..
else
    echo -e "${YELLOW}使用扁平化目录结构${NC}"
    python3 generate_site.py data/anchor_data_latest.json
    HTML_FILE="index.html"
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ HTML生成失败${NC}"
    exit 1
fi
echo ""

# Step 4: Git提交
echo -e "${BLUE}[4/5]${NC} 提交到Git..."
echo -e "${CYAN}提交信息：$COMMIT_MSG${NC}"

if [ -d "public-site" ]; then
    git add data/anchor_data_latest.json public-site/index.html
else
    git add data/anchor_data_latest.json index.html
fi

git commit -m "$COMMIT_MSG" || {
    echo -e "${YELLOW}⚠️  没有新的变更需要提交${NC}"
}
echo ""

# Step 5: 推送到GitHub
echo -e "${BLUE}[5/5]${NC} 推送到GitHub..."
echo -e "${YELLOW}⚠️  准备推送到线上仓库...${NC}"

# 检查远程仓库
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
echo -e "${CYAN}远程仓库：$REMOTE_URL${NC}"

if [[ ! $REMOTE_URL =~ "18310258538-max/yanzhisuren" ]]; then
    echo -e "${RED}❌ 警告：当前远程仓库不是线上仓库！${NC}"
    echo -e "${YELLOW}当前：$REMOTE_URL${NC}"
    echo -e "${YELLOW}期望：https://github.com/18310258538-max/yanzhisuren${NC}"
    echo ""
    read -p "是否继续推送？(y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${RED}已取消推送${NC}"
        exit 1
    fi
fi

git push
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 推送失败${NC}"
    echo -e "${YELLOW}💡 提示：${NC}"
    echo "   1. 检查网络连接"
    echo "   2. 确认有推送权限（PAT Token包含repo权限）"
    echo "   3. 确认远程仓库地址正确"
    exit 1
fi
echo ""

echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}║               ✅ 上传完成！                             ║${NC}"
echo -e "${GREEN}║                                                       ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📊 更新信息：${NC}"
echo -e "   提交信息：$COMMIT_MSG"
echo ""
echo -e "${YELLOW}🌐 等待1-2分钟后，访问以下地址查看：${NC}"
echo -e "${BLUE}   https://18310258538-max.github.io/yanzhisuren/${NC}"
echo ""
echo -e "${CYAN}💡 提示：清除浏览器缓存（Cmd+Shift+R）以查看最新数据${NC}"
echo ""
