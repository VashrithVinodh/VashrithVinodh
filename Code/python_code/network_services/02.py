import argparse
import paramiko

parser = argparse.ArgumentParser(
    prog='02.py'
)

parser.add_argument('hostname', help='The name of the host to SSH into')
parser.add_argument('username', help='The name of the user that is being user for SSH')
parser.add_argument('command_string', help='The bash commands that will be run using your script')
parser.add_argument('output', help='The name of the file that will contain the output of whatever commands were run')
args = parser.parse_args()

client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect(args.hostname, username=args.username, key_filename='keyfile.pem')

stdin, stdout, stderr = client.exec_command(args.command_string)

with open(args.output, 'a') as file:
    file.write(stdout.read(-1).decode())
    file.close()

client.close()