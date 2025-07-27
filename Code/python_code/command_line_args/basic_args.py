from requests import get
import json
import time

# base_url = 'https://pkmn.beacom.xyz/api/v2/'
base_url = 'https://pokeapi.co/api/v2/'

pokemon = 'pokemon/'
evol_chain = 'evolution-chain/'

# resp = get(base_url + pokemon + 'geodude')

for i in range(975, 990):
    resp = get(base_url + pokemon + str(i))

    # print(resp.status_code)
    # print(resp.text)
    # print(resp.json())
    # print(type(resp.json()))

    data = resp.json()

    # convert string to json if needed
    # print(type(resp.text))
    # print(json.loads(resp.text))
    # data = json.loads(resp.text)

    # print(data.keys())

    pokemon_name = (data['name'])
    pokemon_types = []

    for x in data['types']:
        pokemon_types.append(x['type']['name'])

    print(f'Name: {pokemon_name} --- Type', end='')
    
    if len(pokemon_types) == 1:
        print(f': {pokemon_types[0]}')
    else:
        print('s: ', end='')
        for x in pokemon_types:
            print(f'{x} and ', end='')
        print()

    time.sleep(1)