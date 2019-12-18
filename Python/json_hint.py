'''
json package documentation:
https://docs.python.org/3/library/json.html
'''

import json

def string2json(json_string):
    return json.loads(json_string)

def json2string(json_data):
    '''
    actually indent is optional, simply putting here to make it look better
        so as below in save_json
    '''
    return json.dumps(json_data, indent=4)

def save_json(json_file, data):
    '''
    encoding and ensure_ascii are here to make this piece of code more robust in practice
    indent is here to make it look pretty and well-organized
        actually without indentation it takes less space
    '''
    with open(json_file, mode='w', encoding="utf-8") as outfile:
        json.dump(data, outfile, ensure_ascii=False, indent=4)

def load_json(json_file):
    with open(json_file, mode='r', encoding="utf-8") as infile:
        data = json.load(infile)
    return data

toydata = {'people':[{'first_name': 'Zhiping', 'middle_name': None, 'last_name': 'Xiao', 'nickname': 'Patricia'}]}
fname = "./toy_sample_json.json"

toydata_string = json2string(toydata)

print(toydata_string)

save_json(fname, toydata)
print(load_json(fname))