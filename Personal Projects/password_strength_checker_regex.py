import re

def len_checker(password):
    check = r'^.{6,}$'
    return re.match(check, password)
    
def upper_checker(password):
    return re.search(r'[A-Z]', password)

def lower_checker(password):
    return re.search(r'[a-z]', password)

def special_checker(password):
    check = re.compile('[@_!#$%^&*()<>?/\|}{~:]')
    return check.search(password)

def digit_checker(password):
    return re.search(r'\d', password)


def main():
    while True:
        password = input('Enter a password that has the following (6 characters, one lowercase letter, one uppercase letter, one number, and one special character): ')

        if not len_checker(password):
            print('Your password needs to be greater than 6 characters')
        elif not upper_checker(password):
            print('Your password needs to have at least one uppercase letter')
        elif not lower_checker(password):
            print('Your password needs to have at least one lowercase letter')
        elif not special_checker(password):
            print('Your password needs to have at least one special character')
        elif not digit_checker(password):
            print('Your password needs to have at least one number')
        else:
            print('SUCCESS: You have created a strong password.')
            break

if __name__ == "__main__":
    main()