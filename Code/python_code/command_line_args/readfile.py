import argparse

parser = argparse.ArgumentParser(
    prog='read_file.py',
)

parser.add_argument('filename')
parser.add_argument('-c', '--character')

args = parser.parse_args()

print(args)

with open(args.filename, 'r') as f:
    count = 1

    for line in f:
        print(f'{count}: {line.lstrip()}')
        count += 1