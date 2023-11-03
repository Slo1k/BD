#!/usr/bin/env python3
# -*-coding:utf-8 -*
import sys

current_key = None
current_ratings_sum = 0
current_ratings_count = 0
current_apps_count = 0

for line in sys.stdin:
    id_year, r, rc = line.split(',')
    key = id_year
    rating = float(r)
    rating_count = int(rc)

    if current_key == key:
        current_ratings_sum += rating*rating_count
        current_ratings_count += rating_count
        current_apps_count += 1
    else:
        if current_key:
            developer_id, year = current_key.split("-")
            print(f'{developer_id}\t{year}\t{current_ratings_sum}\t{current_ratings_count}\t{current_apps_count}')
        current_ratings_sum = rating * rating_count
        current_ratings_count = rating_count
        current_apps_count = 1
        current_key = key
        current_key_developer_id, current_key_year = key.split('-')

if current_key == key:
    developer_id, year = current_key.split("-")
    print(f'{developer_id}\t{year}\t{current_ratings_sum}\t{current_ratings_count}\t{current_apps_count}')