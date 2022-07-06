import ast
import requests
from bs4 import BeautifulSoup as bs


def get_img_id(i):

    html = 'https://cdn.pr0xy.io/zipcy/metadata/' + str(i)
    res = requests.get(html)
    res_dict = ast.literal_eval(res.content.decode("utf-8"))
    return res_dict['image'][7:]
