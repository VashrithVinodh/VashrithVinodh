import argparse
from bs4 import BeautifulSoup

parser = argparse.ArgumentParser(
    prog='01.py'
)

parser.add_argument('filename')
args = parser.parse_args()

with open (args.filename) as file:
    the_page = file.read(-1)


soup = BeautifulSoup(the_page, 'html.parser')
cve_num = soup.find('h2').text.strip()
desc = soup.find('th', string='Description').find_next('td').text.strip()
cna = soup.find('th', string='Assigning CNA').find_next('td').text.strip()

tds = soup.find_all("td")
for td in tds:
    text = td.text.strip() 
    if text.isdigit():     
        date = text

print(f'CVE-Number: {cve_num}')
print(f'Description: {desc}')
print(f'Assigning CNA: {cna}')
print(f'Date Record Created: {date}')