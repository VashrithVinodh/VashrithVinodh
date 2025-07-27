#!/bin/bash


# ssh root@192.168.1.8 'ip -c a'
# ssh root@192.168.1.8 'uname -a'
VAR1=1337

ssh root@192.168.1.8 << 'EOF'
    uname -a
    #ip -c a
    #echo $(ls -a)
    for x in $(seq 1 5); do echo "hi $x"; done

EOF

# ip -c a