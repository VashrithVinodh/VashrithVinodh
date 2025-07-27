from requests import get
from bs4 import BeautifulSoup
from time import sleep

the_page = ''

# Mechanism for getting the page
base_url = 'https://bulbapedia.bulbagarden.net'
current_page = '/wiki/Ivysaur_(Pok%C3%A9mon)'

for i in range(5):
    the_page = get(base_url + current_page).text

    # get link to next page
    soup = BeautifulSoup(the_page, 'html.parser')

    # look for cool pokemon facts
    pokemon_name = soup.title.text.split(' (')[0]
    type1 = soup.find_all('a', string="Type")[0].parent.parent.find_all('b')[1]
    type2 = soup.find_all('a', string="Type")[0].parent.parent.find_all('b')[2]

    # print output
    print(f'Pokemom: {pokemon_name} with first type: {type1} and second type: {type2}')

    # find the next page then iterate
    current_page = soup.table.find_all('a')[5]['href']
    sleep(5)