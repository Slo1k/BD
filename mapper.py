#!/usr/bin/env python3
# -*-coding:utf-8 -*
import sys
import re

date_pattern = r'[A-Za-z]{3}\s(\d{1,2}),\s(\d{4})'

for line in sys.stdin:
    values = line.strip().split('\u0001')
    if len(values) == 22:
        year_matches = re.match(date_pattern, values[13])
        rating_count_string = rating_count = values[4]
        developer_id = values[-1]
        rating = values[3]
        if year_matches and rating_count_string != 'null' and developer_id != 'null' and rating != 'null':
            year = year_matches.group(2)
            rating_count = int(rating_count_string)

            if int(rating_count) >= 1000:
                print(f'{developer_id}-{year},{rating},{rating_count}')
