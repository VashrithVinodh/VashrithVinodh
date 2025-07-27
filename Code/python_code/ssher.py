import paramiko

# setup ssh client
client = paramiko.SSHClient()

# allow to connect to new servers automatically
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

# initiates connection to the server using our keyfile
client.connect('dev.hostbin.org', username='csc443.user1', key_filename='keyfile.pem')

# executes a commmand over the ssh connection
stdin, stdout, stderr = client.exec_command('ls -l')

# read the output
print(stdout.read(-1).decode())

# close the connection
client.close()