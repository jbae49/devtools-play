import ast
import ssl
import urllib.request
import datetime
import requests
import time
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
from retry import retry

gauth = GoogleAuth()
drive = GoogleDrive(gauth)

gdrive_id = "1sAxlGG8mDqctnHmNm0i78AogRjIjpe9q"

ssl._create_default_https_context = ssl._create_unverified_context


def get_img_id(i):
    html = "https://cdn.pr0xy.io/zipcy/metadata/" + str(i)
    res = requests.get(html)
    res_dict = ast.literal_eval(res.content.decode("utf-8"))
    return res_dict["image"][7:]


now = datetime.datetime.now()


@retry(urllib.error.URLError, tries=5)
def main(i):
    print(i)
    filename = "%s.png" % i
    time.sleep(1)
    urllib.request.urlretrieve("https://ipfs.io/ipfs/" + get_img_id(i), filename)
    gfile = drive.CreateFile({"parents": [{"id": gdrive_id}]})
    gfile.SetContentFile(filename)
    gfile.Upload()


for i in range(1471, 8888):
    try:
        main(i)
    except Exception as e:
        print(f"{i}: {e}")

print(datetime.datetime.now() - now)
# Took 0:04:55.492272 secs
