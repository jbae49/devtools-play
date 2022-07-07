import ssl
from urllib.request import urlopen

import requests
from bs4 import BeautifulSoup, SoupStrainer
import pandas as pd

ssl._create_default_https_context = ssl._create_unverified_context

rekt = "https://rekt.news/leaderboard/"

get_url = requests.get(rekt)
get_text = get_url.text
soup = BeautifulSoup(get_text, "html.parser")
protocols = soup.select('div.leaderboard-row-title')

websites = soup.find_all("a", href=True)
leaderboard = [web['href'] for web in websites]
leaderboard = leaderboard[5:-7]

# print(leaderboard[0])

projects = []
addresses = []
rekt_link = []


for hack in leaderboard:
    url = "https://rekt.news" + hack
    rekt_link.append(url)

    project_name = hack.split('-')[0].replace('/','')
    projects.append(project_name)

    add = []
    get_url = requests.get(url)
    get_text = get_url.text
    soup = BeautifulSoup(get_text, "html.parser")

    links = soup.find_all("a", href=True)
    for link in links:
        if 'scan.com' in link['href'] or 'scan.io' in link['href']:
            add.append(link['href'])
    addresses.append(add)


df = pd.DataFrame({'rekt_link': rekt_link, 'project': projects, 'relevant addresses': addresses})
df.to_csv('rekt_leaderboard.csv')
# # for link in BeautifulSoup(response.content, "html.parser", parse_only=SoupStrainer('a', href=True)):
# #     print(link['href'])

# # print('=======')
# # protocols = soup.find_all('div')
# # print(len(protocols))
# # print(type(protocols[0]))
# # print(protocols[0].select('div.ReviewCell_review_head_cell__1UA0m'))
# # # for p in protocols:
# # #     if "review_head_cell_project" in p:
# # #         print(p)

    