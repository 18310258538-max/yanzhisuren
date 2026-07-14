#!/bin/bash
# install_dependencies.sh - 安装项目依赖
# 用法：./install_dependencies.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  安装项目依赖${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查Python 3
echo -e "${BLUE}[1/3]${NC} 检查Python 3..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✅ Python已安装：$PYTHON_VERSION${NC}"
else
    echo -e "${RED}❌ Python 3 未安装${NC}"
    echo -e "${YELLOW}请先安装Xcode Command Line Tools：${NC}"
    echo "   xcode-select --install"
    exit 1
fi
echo ""

# 检查pip3
echo -e "${BLUE}[2/3]${NC} 检查pip3..."
if command -v pip3 &> /dev/null; then
    PIP_VERSION=$(pip3 --version)
    echo -e "${GREEN}✅ pip3已安装：$PIP_VERSION${NC}"
else
    echo -e "${RED}❌ pip3 未安装${NC}"
    echo -e "${YELLOW}尝试安装pip3...${NC}"
    python3 -m ensurepip --upgrade
fi
echo ""

# 安装openpyxl
echo -e "${BLUE}[3/3]${NC} 安装openpyxl（Excel处理库）..."
pip3 install --user openpyxl

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ openpyxl安装成功${NC}"
else
    echo -e "${RED}❌ openpyxl安装失败${NC}"
    exit 1
fi
echo ""

# 验证安装
echo -e "${BLUE}验证安装...${NC}"
python3 -c "import openpyxl; print('openpyxl版本:', openpyxl.__version__)"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ✅ 所有依赖安装完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${YELLOW}📍 下一步：运行初始化脚本${NC}"
    echo "   ./init_repo.sh"
else
    echo -e "${RED}❌ 验证失败${NC}"
    exit 1
fi
