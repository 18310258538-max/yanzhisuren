#!/bin/bash
# update_site.sh - 颜值素人奖励公示系统一键更新脚本
# 用法：./update_site.sh "7.14颜值素人奖励公示名单表.xlsx"

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  颜值素人奖励公示系统 - 自动更新${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查参数
if [ -z "$1" ]; then
    echo -e "${RED}❌ 错误：请提供Excel文件路径${NC}"
    echo "用法：./update_site.sh \"7.14颜值素人奖励公示名单表.xlsx\""
    exit 1
fi

EXCEL_FILE="$1"

# 检查文件是否存在
if [ ! -f "$EXCEL_FILE" ]; then
    echo -e "${RED}❌ 错误：文件不存在 - $EXCEL_FILE${NC}"
    exit 1
fi

# 提取日期（用于commit消息）
FILENAME=$(basename "$EXCEL_FILE")
DATE_STR=$(echo "$FILENAME" | grep -oE '[0-9]+\.[0-9]+' | head -1)
if [ -z "$DATE_STR" ]; then
    DATE_STR=$(date +%m.%d)
fi

echo -e "${YELLOW}📁 Excel文件：$EXCEL_FILE${NC}"
echo -e "${YELLOW}📅 更新日期：$DATE_STR${NC}"
echo ""

# Step 1: 转换Excel为JSON
echo -e "${BLUE}[1/4]${NC} 转换Excel为JSON..."
python3 convert_excel_to_json.py "$EXCEL_FILE"
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Excel转JSON失败${NC}"
    exit 1
fi
echo ""

# Step 2: 生成新的HTML
echo -e "${BLUE}[2/4]${NC} 生成新的HTML页面..."
cd public-site
python3 generate_site.py
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ HTML生成失败${NC}"
    exit 1
fi
cd ..
echo ""

# Step 3: Git提交
echo -e "${BLUE}[3/4]${NC} 提交到Git..."
git add data/anchor_data_latest.json public-site/index.html
git commit -m "更新${DATE_STR}日奖励公示数据" || {
    echo -e "${YELLOW}⚠️  没有新的变更需要提交${NC}"
}
echo ""

# Step 4: 推送到GitHub
echo -e "${BLUE}[4/4]${NC} 推送到GitHub..."
git push
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 推送失败${NC}"
    echo -e "${YELLOW}💡 提示：请检查网络连接和GitHub认证${NC}"
    exit 1
fi
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✅ 更新完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}📊 数据已更新：${DATE_STR}${NC}"
echo -e "${YELLOW}🌐 等待1-2分钟后，访问以下地址查看：${NC}"
echo -e "${BLUE}   https://[你的GitHub账号].github.io/yanzhisuren/${NC}"
echo ""
