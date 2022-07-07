from urllib.request import urlopen
import ssl
import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

ssl._create_default_https_context = ssl._create_unverified_context

# url1 = "https://www.defisafety.com/app/pqrs/454"
# url2 = "https://www.defisafety.com/app/pqrs/199"
# url2 = "https://www.defisafety.com/app/pqrs/200"
pqrs_url = "https://www.defisafety.com/app/pqrs/"

# urls = [url1, url2]

companies = []
scores = []
websites = []
githubs = []
audits = []
protocolsused = []

# for url in urls:
for i in range(1,1000):
    if i % 50 == 0:
        print(i)
    url = pqrs_url + str(i)
    # print(url)
    try:
        get_url = requests.get(url)
        # print(get_url.status_code)
        time.sleep(1)
        get_text = get_url.text
        soup = BeautifulSoup(get_text, "html.parser")

        company = soup.select('h1.OverviewSection_title__3kRRd')[0].text
        companies.append(company)
        # print(f'company: {company}')

        score = soup.select('span.OverviewSection_final_score_value__1QwX4')[0].text
        scores.append(score)
        # print(f'score: {score}')

        website = soup.find_all("a", href=True)[1]['href']
        websites.append(website)
        # print(f'website: {website}')

        github = soup.find_all("a", href=True)[4]['href']
        githubs.append(github)
        # print(f'github: {github}')

        # urls = soup.find_all("a", href=True)
        # print([url['href'] for url in urls])


        protocols = soup.select('div.BlockchainProtocol_value__3WAlO')
        protocolsused.append([p.text for p in protocols])
        # print(f'The blockchain used by this protocol: {[p.text for p in protocols]}')

        # audit = soup.findAll('div', attrs={"class": "MarkdownRenderer_markdownRenderer__3BGWb"})
        # for x in audit:
        #     print(x.find('p').text)

        au = []
        audit_info = soup.select('div.MarkdownRenderer_markdownRenderer__3BGWb')
        for p in audit_info:
            if "audit" in p.text:
                au.append(p.text)
                # print(p.text)
        audits.append(au)
    # print(f'Is the protocol audited?: {audit.find("p").text}')
    except Exception as e:
        pass


df = pd.DataFrame({'Project': companies, 'Website': websites, 'Protocols': protocolsused, 'DefiSafety Score': scores, 'Audit': audits, 'Github': githubs})
df.to_csv('defisafety_dashboard.csv')
# print(websites[1])
# for website in websites:
#     print(website['href'])


# page = urlopen(url)
# html_bytes = page.read()
# html = html_bytes.decode("utf-8")

# print(html)