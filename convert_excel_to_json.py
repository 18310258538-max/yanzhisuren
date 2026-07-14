#!/usr/bin/env python3
"""
convert_excel_to_json.py
将颜值素人奖励Excel表格转换为JSON格式
用法：python3 convert_excel_to_json.py "6.16颜值素人奖励公示名单表.xlsx"
"""

import sys
import json
import os
from datetime import datetime

def convert_excel_to_json(excel_file):
    """将Excel文件转换为JSON"""
    try:
        import openpyxl
    except ImportError:
        print("❌ 缺少依赖库 openpyxl")
        print("请运行：pip3 install openpyxl")
        sys.exit(1)
    
    if not os.path.exists(excel_file):
        print(f"❌ 文件不存在：{excel_file}")
        sys.exit(1)
    
    print(f"📖 正在读取：{excel_file}")
    
    wb = openpyxl.load_workbook(excel_file, data_only=True)
    sheet = wb.active
    
    # 读取表头（第一行）
    headers = []
    for cell in sheet[1]:
        headers.append(cell.value)
    
    print(f"📋 表头字段：{headers}")
    
    # 读取数据行
    records = []
    for row_idx, row in enumerate(sheet.iter_rows(min_row=2, values_only=True), start=2):
        if not any(row):  # 跳过空行
            continue
        
        record = {}
        for col_idx, value in enumerate(row):
            if col_idx < len(headers):
                header = headers[col_idx]
                if header:  # 只处理有表头的列
                    # 清理数据
                    if value is None or str(value).strip() in ('', 'None', 'nan'):
                        record[header] = ''
                    else:
                        # 移除末尾的 .0（如果是整数型浮点数）
                        value_str = str(value).strip()
                        if value_str.endswith('.0') and value_str[:-2].isdigit():
                            record[header] = value_str[:-2]
                        else:
                            record[header] = value_str
        
        # 特殊处理：快手ID为0时转为空字符串
        if '快手ID' in record and record['快手ID'] in ('0', '0.0'):
            record['快手ID'] = ''
        
        if record:  # 只添加非空记录
            records.append(record)
    
    print(f"✅ 读取完成：共 {len(records)} 条有效数据")
    
    # 保存为JSON
    output_file = 'data/anchor_data_latest.json'
    os.makedirs('data', exist_ok=True)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(records, f, ensure_ascii=False, indent=2)
    
    file_size = os.path.getsize(output_file) / 1024
    print(f"💾 已保存到：{output_file} ({file_size:.1f} KB)")
    
    return len(records)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("用法：python3 convert_excel_to_json.py <Excel文件路径>")
        print("示例：python3 convert_excel_to_json.py '7.14颜值素人奖励公示名单表.xlsx'")
        sys.exit(1)
    
    excel_file = sys.argv[1]
    convert_excel_to_json(excel_file)
