from bs4 import BeautifulSoup

the_page = ""

with open('asdf.htm') as file:
    the_page = file.read(-1)

# print(the_page)

soup = BeautifulSoup(the_page, 'html.parser')
print(soup.prettify())
print(soup.title.text)

print(soup.a)
print(soup.a['href'])