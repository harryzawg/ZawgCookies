# place cookies.txt file in here
import re

with open('cookies.txt', 'r') as file:
    cookies_data = file.read()

# define cookie pattern
pattern = re.compile(r'domain: "(.*?)".*?path: "(.*?)".*?secure: (true|false).*?expires: Some\((\d+)\).*?name: "(.*?)".*?value: "(.*?)".*?http_only: (true|false).*?same_site: (\d+)', re.DOTALL)

formatted_cookies = []

# extract individual cookies
matches = re.findall(pattern, cookies_data)

# parse each cookie and convert it to Netscape format
for match in matches:
    domain, path, secure, expires, name, value, http_only, same_site = match
    secure = 'TRUE' if secure == 'true' else 'FALSE'
    expires = expires if expires else ''
    http_only = 'TRUE' if http_only == 'true' else 'FALSE'
    # Construct the formatted cookie string
    formatted_cookie = "\t".join([domain, secure, path, 'TRUE' if expires else 'FALSE', expires, name, value])
    # Append the formatted cookie to the list
    formatted_cookies.append(formatted_cookie)

# save
with open('net_cookies.txt', 'w') as file:
    file.write("# Netscape HTTP Cookie File\n")
    file.write("# Auto generated file! Do not edit!\n")
    file.write("# Made by zawg woah woah\n")
    for cookie in formatted_cookies:
        file.write(cookie + '\n')
