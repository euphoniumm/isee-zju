import requests
import bs4
import os
import datetime
import time

def fetchUrl(url):
    # 功能：访问 url 的网页，获取网页内容并返回
    # 参数：目标网页的 url
    # 返回：目标网页的 html 内容

    headers = {
        'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36',
    }

    r = requests.get(url, headers=headers)
    r.raise_for_status()
    r.encoding = r.apparent_encoding
    # 返回：目标网页的 html 内容
    return r.text


def getPageList(year, month, day):

    # 功能：获取当天报纸的各版面的链接列表
    # 参数：年，月，日，改变年月日拼接成需要爬取的url
    # 返回当天报纸的各版面的链接列表

    url = 'http://paper.people.com.cn/rmrb/html/' + year + '-' + month + '/' + day + '/nbs.D110000renmrb_01.htm'
    html = fetchUrl(url)
    bsobj = bs4.BeautifulSoup(html, 'html.parser')
    temp = bsobj.find('div', attrs={'id': 'pageList'})
    if temp:
        pageList = temp.ul.find_all('div', attrs={'class': 'right_title-name'})
    else:
        pageList = bsobj.find('div', attrs={'class': 'swiper-container'}).find_all('div', attrs={'class': 'swiper-slide'})
    linkList = []

    for page in pageList:
        link = page.a["href"]
        url = 'http://paper.people.com.cn/rmrb/html/' + year + '-' + month + '/' + day + '/' + link
        linkList.append(url)
    # 返回当天报纸的各版面的链接列表
    return linkList


def getTitleList(year, month, day, pageUrl):

    # 功能：获取报纸某一版面的文章链接列表
    # 参数：年，月，日，该版面的链接

    html = fetchUrl(pageUrl)
    bsobj = bs4.BeautifulSoup(html, 'html.parser')
    temp = bsobj.find('div', attrs={'id': 'titleList'})
    if temp:
        titleList = temp.ul.find_all('li')
    else:
        titleList = bsobj.find('ul', attrs={'class': 'news-list'}).find_all('li')
    linkList = []

    for title in titleList:
        tempList = title.find_all('a')
        for temp in tempList:
            link = temp["href"]
            if 'nw.D110000renmrb' in link:
                url = 'http://paper.people.com.cn/rmrb/html/' + year + '-' + month + '/' + day + '/' + link
                linkList.append(url)
    return linkList


def getContent(html):

    # 功能：解析 HTML 网页，获取新闻的文章内容
    # 参数：html 网页内容
    # 返回结果 标题+内容

    bsobj = bs4.BeautifulSoup(html, 'html.parser')

    # 获取文章 标题
    title = bsobj.h3.text + '\n' + bsobj.h1.text + '\n' + bsobj.h2.text + '\n'
    # print(title)

    # 获取文章 内容
    pList = bsobj.find('div', attrs={'id': 'ozoom'}).find_all('p')
    content = ''
    for p in pList:
        content += p.text + '\n'
    # print(content)

    # 返回结果 标题+内容
    resp = title + content
    return resp


def saveFile(content, path, filename):

    # 功能：将文章内容 content 保存到本地文件中
    # 参数：要保存的内容，路径，文件名
    # 如果没有该文件夹，则自动生成
    if not os.path.exists(path):
        os.makedirs(path)
        print('爬取到文章，正在下载中...')
        
    # 保存文件
    with open(path + filename, 'w', encoding='utf-8') as f:
        f.write(content)
    print('爬取到文章，正在下载中...')
    print('文章已写入：' + path)


def download_rmrb(year, month, day, destdir):

    # 功能：爬取《人民日报》网站某年,某月,某日的新闻内容，并保存在指定目录下
    # 参数：年，月，日，文件保存的根目录
    # 保存文件

    pageList = getPageList(year, month, day)
    for page in pageList:
        titleList = getTitleList(year, month, day, page)
        for url in titleList:

            # 获取新闻文章内容
            html = fetchUrl(url)
            content = getContent(html)

            # 生成保存的文件路径及文件名
            temp = url.split('_')[2].split('.')[0].split('-')
            pageNo = temp[1]
            titleNo = temp[0] if int(temp[0]) >= 10 else '0' + temp[0]
            path = destdir + '/' + year + month + day + '/'
            fileName = year + month + day + '-' + pageNo + '-' + titleNo + '.txt'

            # 保存文件
            saveFile(content, path, fileName)


def gen_dates(b_date, days):
    day = datetime.timedelta(days = 1)
    for i in range(days):
        yield b_date + day * i


def get_date_list(beginDate, endDate):
    # 获取日期列表
    # :param start: 开始日期
    # :param end: 结束日期
    start = datetime.datetime.strptime(beginDate, "%Y%m%d")
    end = datetime.datetime.strptime(endDate, "%Y%m%d")

    data = []
    for d in gen_dates(start, (end-start).days):
        data.append(d)
    # return: 返回开始日期和结束日期之间的日期列表
    return data    


# 主函数：程序入口
if __name__ == '__main__':
    
    # 输入起止日期，爬取之间的新闻
    print('---文章爬取系统---')
    beginDate = input('请输入开始日期(格式如20220706):')
    endDate = input('请输入结束日期(格式如20220706):')
    data = get_date_list(beginDate, endDate)

    for d in data:
        year = str(d.year)
        month = str(d.month) if d.month >= 10 else '0' + str(d.month)
        day = str(d.day) if d.day >= 10 else '0' + str(d.day)
        # 爬取后文章t统一存到这个文件夹,没有会自动创建
        destdir = "./人民日报"

        download_rmrb(year, month, day, destdir)
        print('---文章爬取系统---')
        print("爬取文章完成！")
        print('爬取文章时间为：' + year + '/' + month + '/' + day + '的文章已成功写入文件夹中！')
        print('---文章爬取系统---')