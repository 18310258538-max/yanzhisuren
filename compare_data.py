#!/usr/bin/env python3
"""
compare_data.py - 对比两个JSON文件，统计新增和变化
用法：python3 compare_data.py old.json new.json
"""

import json
import sys
import os

def load_json(filepath):
    """加载JSON文件"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return json.load(f)

def get_record_key(record):
    """生成记录的唯一标识"""
    # 使用主播ID + 奖励明细 + 填入时间作为唯一标识
    anchor_id = record.get('主播ID') or record.get('anchor_id') or ''
    reward = record.get('奖励明细\n小火苗/涨粉/流量券') or record.get('奖励明细') or record.get('reward') or ''
    fill_time = record.get('奖励填入时间') or record.get('奖励登记时间') or record.get('fill_time') or ''
    return f"{anchor_id}|{reward}|{fill_time}"

def compare_data(old_file, new_file):
    """对比两个数据文件"""
    
    print(f"📖 读取旧数据：{old_file}")
    old_data = load_json(old_file)
    old_count = len(old_data)
    print(f"   旧数据记录数：{old_count}")
    
    print(f"📖 读取新数据：{new_file}")
    new_data = load_json(new_file)
    new_count = len(new_data)
    print(f"   新数据记录数：{new_count}")
    
    # 建立旧数据的索引
    old_keys = {get_record_key(r) for r in old_data}
    
    # 找出新增的记录
    new_records = []
    for record in new_data:
        key = get_record_key(record)
        if key not in old_keys:
            new_records.append(record)
    
    added_count = len(new_records)
    
    print("\n" + "="*50)
    print("📊 对比结果")
    print("="*50)
    print(f"旧数据总数：{old_count} 条")
    print(f"新数据总数：{new_count} 条")
    print(f"新增记录：{added_count} 条")
    print(f"数据增长：{new_count - old_count:+d} 条")
    
    if added_count > 0:
        print("\n✨ 新增记录预览（前5条）：")
        for i, record in enumerate(new_records[:5], 1):
            anchor_id = record.get('主播ID') or record.get('anchor_id') or '-'
            anchor_name = record.get('主播昵称') or record.get('anchor_name') or '-'
            reward = record.get('奖励明细\n小火苗/涨粉/流量券') or record.get('奖励明细') or record.get('reward') or '-'
            print(f"  {i}. 主播ID: {anchor_id}, 昵称: {anchor_name}, 奖励: {reward}")
        
        if added_count > 5:
            print(f"  ... 还有 {added_count - 5} 条新增记录")
    
    # 生成提交信息
    print("\n📝 建议的Git提交信息：")
    from datetime import datetime
    date_str = datetime.now().strftime('%Y-%m-%d')
    commit_msg = f"auto: daily update {date_str} ({new_count}条，含{added_count}条新增)"
    print(f"   {commit_msg}")
    
    return {
        'old_count': old_count,
        'new_count': new_count,
        'added_count': added_count,
        'commit_message': commit_msg
    }

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("用法：python3 compare_data.py <旧JSON文件> <新JSON文件>")
        print("示例：python3 compare_data.py data/old.json data/anchor_data_latest.json")
        sys.exit(1)
    
    old_file = sys.argv[1]
    new_file = sys.argv[2]
    
    if not os.path.exists(old_file):
        print(f"❌ 旧文件不存在：{old_file}")
        sys.exit(1)
    
    if not os.path.exists(new_file):
        print(f"❌ 新文件不存在：{new_file}")
        sys.exit(1)
    
    compare_data(old_file, new_file)
