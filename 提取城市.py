from bs4 import BeautifulSoup
import requests
import xlwt
import time
import os
import xlrd
from itertools import chain
import os
import xlrd
import json
import urllib
import math


firsturl = 'http://api.map.baidu.com/place/v2/suggestion?query='
last = '&ak=vqwTs1wnlhs9dY2Y65keppia1DqTwVF7'
middle = '&region=中国&city_limit=false'
# 导入地址
os.chdir('E:\数据库\创新\城市提取')
file = '1.xlsx'
wb = xlrd.open_workbook(filename=file)
ws = wb.sheet_by_name('Sheet2')
nrow = ws.nrows
urls = []
for r in range(0,150):
    col = []
    for c in range(0 , 1):
        col.append(ws.cell(r, c).value)
        coll = col[0]
        url = firsturl + coll + middle + last
        urls.append(url)


def get_info(xx):
    workbook = xlwt.Workbook(encoding='utf-8')
    booksheet = workbook.add_sheet('Sheet 1', cell_overwrite_ok=True)
    for i, row in enumerate(xx):
        for j, col in enumerate(row):
            booksheet.write(i, j, col)
    workbook.save('1-city.xls')
# 从百度地图端口得到数据
def get_url(urls):
    xx = []
    for url in urls:
        wb_data = requests.get(url)
        soup = BeautifulSoup(wb_data.text, 'lxml')
        statuss = soup.find_all('status')
        citys = soup.select('city')  # 经度
        names = soup.select('name')
        if statuss and citys and names:
            data = (statuss[0].text, citys[0].text, names[0].text)
        else:
            data = ('0','null','250')
        xx.append(data)
        for x in range(1,150):
            if len(xx)==50*x or len(xx)==999:
                get_info(xx)

#存入


 # 转换坐标


get_url(urls)
