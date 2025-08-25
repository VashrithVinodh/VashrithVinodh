import string

def len_checker(password):
    return len(password) >= 6
    
def upper_checker(password):
    for c in password:
        if c in string.ascii_uppercase:
            return True
    return False

def lower_checker(password):
    for c in password:
        if c in string.ascii_lowercase:
            return True
    return False

def special_checker(password):
    for c in password:
        if c in string.punctuation:
            return True
    return False

def digit_checker(password):
    for c in password:
        if c in string.digits:
            return True
    return False


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