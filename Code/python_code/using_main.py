
def print_dashes(num_dashes):
    for i in range(num_dashes):
        print('-', end='')
    print()


def print_dashes_but_cooler(num_dashes):
    print('-' * num_dashes)


def count_letter(string, letter):
    count = 0
    for let in string:
        if let == letter:
            count+=1
    return count


def main():
    print('Hello World')

    print_dashes(17)
    print('After Dashes')

    print_dashes_but_cooler(17)

    result = count_letter('Vashrith Vinodh', 'i')
    print(result)

    result = count_letter('Vashrith Vinodh', 'a')
    print(result)


if __name__ == '__main__':
    main()