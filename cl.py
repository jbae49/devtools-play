import urllib.request
from retry import retry

LINKS = [
    "https://ipfs.io/ipfs/QmQZW48zv2drAYFhkhLrFTV3LhGheK6g4YiNWNtrN7K4b2"
    ]

@retry(urllib.error.URLError, tries=10)
def download(index, url):
    filename = "%s.png" % index
    urllib.request.urlretrieve(url, filename)

def main():
    for index, link in enumerate(LINKS):
        print(index, link)
        download(index, link)

if __name__ == '__main__':
    main()