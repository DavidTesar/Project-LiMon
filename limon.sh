#! /bin/bash
if [[ $EUID -ne 0 ]]
then
    printf 'Must be run as root, exiting!\n'
    exit 1
fi

show_art(){
    # Display a banner
    figlet "LiMon Debian" -c
    echo "
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⡶⢿⣿⣿⣿⠿⠿⠿⠿⠟⠛⢋⣁⣤⡴⠂⣠⡆⠀
⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣶⣤⣤⣤⣤⣤⣴⣶⣶⣿⣿⣿⡿⠋⣠⣾⣿⠁⠀
⠀⠀⠀⠀⠀⢀⣴⣤⣄⡉⠛⠻⠿⠿⣿⣿⣿⣿⡿⠿⠟⠋⣁⣤⣾⣿⣿⣿⠀⠀
⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣶⣶⣤⣤⣤⣤⣤⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⡇⠀
⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀
⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀
⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⡟⢸⡟⠀⠀
⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣷⡿⢿⡿⠁⠀⠀
⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢁⣴⠟⢀⣾⠃⠀⠀⠀
⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⣉⣿⠿⣿⣶⡟⠁⠀⠀⠀⠀
⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⣿⣏⣸⡿⢿⣯⣠⣴⠿⠋⠀⠀⠀⠀⠀⠀
⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⠿⠶⣾⣿⣉⣡⣤⣿⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢸⣿⣿⣿⣿⡿⠿⠿⠿⠶⠾⠛⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠈⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    "
}

# Help banner
show_help(){
    show_art
    echo "Usage: $0 [-h] [-p] [-i] [-r] [-c] [-o]"
    echo ""
    echo "Options:"
    echo "-h  Print this help message"
    echo "-p  Periodically display system info"
    echo "-i  Set up for an integrity check"
    echo "-r  Restores all backed up files"
    echo "-c  Compares /etc/ files for changes"
    echo "-o  Output to /limon/outputs/YYYY_MM_DD_HH_MI.log"
    exit 0
}

#Rotate information
rotate_info(){
    # Enter an infinite loop
    while true;
    do	
        # Display system information using neofetch
        neofetch
        sleep 5

        # Display information about established network connections
        netstat -n -A inet | grep ESTABLISHED > temp
        incoming_ftp=$(cat temp | cut -d ':' -f2 | grep "^21" | wc -l)
        outgoing_ftp=$(cat temp | cut -d ':' -f3 | grep "^21" | wc -l)
        
        incoming_ssh=$(cat temp | cut -d ':' -f2 | grep "^22" | wc -l)
        outgoing_ssh=$(cat temp | cut -d ':' -f3 | grep "^22" | wc -l)	

        outgoing_telnet=$(cat temp | cut -d ':' -f2 | grep "^23" | wc -l)
        incoming_telnet=$(cat temp | cut -d ':' -f3 | grep "^23" | wc -l)

        incoming_telnet=$(cat temp | cut -d ':' -f2 | grep "^^23" | wc -l)
        outgoing_telnet=$(cat temp | cut -d ':' -f3 | grep "^^23" | wc -l)

        # Display information about successful network connections
        echo "[*] ACTIVE NETWORK CONNECTIONS:"
        echo "---------------------------"
        if [ $outgoing_telnet -gt 0 ]; then
            echo $outgoing_telnet successful outgoing telnet connection.
        fi
        
        if [ $incoming_telnet -gt 0 ]; then
            echo $incoming_telnet successful incoming telnet session.
        fi

        if [ $outgoing_ssh -gt 0 ]; then
            echo $outgoing_ssh successful outgoing ssh connection.
        fi
        
        if [ $incoming_ssh -gt 0 ]; then
            echo $incoming_ssh successful incoming ssh session.
        fi
        
        
        if [ $outgoing_ftp -gt 0 ]; then
            echo $outgoing_ftp successful outgoing ftp connection.
        fi
        
        if [ $incoming_ftp -gt 0 ]; then
            echo $incoming_ftp successful incoming ftp session.
        fi

        if [ $incoming_ftp -gt 0 ]; then
            echo $incoming_ftp successful incoming ftp session.
        fi

        # Display the netstat
        cat temp
        sleep 5
        clear

        # Display the processes
        echo "[*] CURRENT PROCESSES:"
        echo "-----------------------"
        ps
        sleep 5
        clear

        # Display the environment variables
        echo "[*] ENVIRONMENT VARIABLES:"
        echo "-----------------------"
        printenv | tail -19
        sleep 5
        clear

        # Display the DNS
        echo "[*] DNS RESOLVING:"
        echo "-----------------------"
        cat /etc/resolv.conf
        sleep 5
        clear

        # Display information about current login sessions
        echo "[*] CURRENT LOGIN SESSIONS:"
        echo "-----------------------"
        w
        echo

        # Display information about recent login sessions
        echo "[*] RECENT LOGIN SESSIONS:"
        echo "----------------------"
        last | head -n5
        sleep 5
        clear

        # # Display information about aliases defined in the shell
        # echo "ALIASES:"
        # echo "--------"
        
        # touch /tmp/aliases
        # alias >> /tmp/aliases
        # # cat /tmp/aliases
        # echo
        # sleep 5
        # clear

        # Display information about aliases defined in the shell
        echo "[*] USERS ABLE TO LOGIN:"
        echo "--------------------"
        grep -v -e "/bin/false" -e "/sbin/nologin" /etc/passwd | cut -d ':' -f1
        sleep 5
        clear
    done
}

# Stores a copy of files for comparison
setup_integrity(){
    echo "[*] Copying configuration files to /limon/backup..."
    sudo mkdir -p /limon/backup/etc/
    sudo cp /etc/fstab /limon/backup/etc/
    sudo cp /etc/passwd /limon/backup/etc/
    sudo cp /etc/group /limon/backup/etc/
    sudo cp /etc/hostname /limon/backup/etc/
    sudo cp /etc/hosts /limon/backup/etc/
    sudo cp /etc/resolv.conf /limon/backup/etc/
    sudo cp /etc/sudoers /limon/backup/etc/
    sudo cp /etc/sysctl.conf /limon/backup/etc/
    sudo cp /etc/logrotate.conf /limon/backup/etc/
    sudo cp /etc/crontab /limon/backup/etc/
    sudo cp /etc/profile /limon/backup/etc/
    
    sudo mkdir -p /limon/backup/etc/network
    sudo cp /etc/network/interfaces /limon/backup/etc/network/

    sudo mkdir -p /limon/backup/etc/apt
    sudo cp /etc/apt/sources.list /limon/backup/etc/apt/
    
    sudo mkdir -p /limon/backup/etc/ssh
    sudo cp /etc/ssh/sshd_config /limon/backup/etc/ssh/

    #sudo mkdir -p /limon/backup/etc/bash
    #sudo cp /etc/bash.bashrc /limon/backup/etc/bash/
    echo "[*] Done!"
}

# Copies backed up files to their original location
restore_integrity() {
    echo "[*] Restoring configuration files from /limon/backup..."
    sudo cp /limon/backup/etc/fstab /etc/
    sudo cp /limon/backup/etc/passwd /etc/
    sudo cp /limon/backup/etc/group /etc/
    sudo cp /limon/backup/etc/hostname /etc/
    sudo cp /limon/backup/etc/hosts /etc/
    sudo cp /limon/backup/etc/resolv.conf /etc/
    sudo cp /limon/backup/etc/sudoers /etc/
    sudo cp /limon/backup/etc/ssh/sshd_config /etc/ssh/
    sudo cp /limon/backup/etc/sysctl.conf /etc/
    sudo cp /limon/backup/etc/logrotate.conf /etc/
    sudo cp /limon/backup/etc/crontab /etc/

    sudo cp /limon/backup/etc/apt/sources.list /etc/apt/
    sudo cp /limon/backup/etc/network/interfaces /etc/network/
    #sudo cp /limon/backup/etc/bash.bashrc /etc/bash.bashrc
    sudo cp /limon/backup/etc/profile /etc/
    echo "[*] Done!"
}

# Checks and displays changes within those files
check_integrity(){
echo "[*] Checking integrity of configuration files..."
echo "[*] Check performed on"
echo $(date +"%Y_%m_%d_%H_%M_%S")
echo "---------------------------------"

# /etc/passwd
    if ! diff -q "/limon/backup/etc/passwd" "/etc/passwd" >/dev/null; then
        echo "[*] Changes detected in /etc/passwd"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/passwd /etc/passwd
    fi

# /etc/fstab
    if ! diff -q "/limon/backup/etc/fstab" "/etc/fstab" >/dev/null; then
        echo "[*] Changes detected in etc/fstab"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/fstab /etc/fstab
    fi
    
# /etc/hostname
    if ! diff -q "/limon/backup/etc/hostname" "/etc/hostname" >/dev/null; then
        echo "[*] Changes detected in /etc/hostname"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/hostname /etc/hostname
    fi

# /etc/group
    if ! diff -q "/limon/backup/etc/group" "/etc/group" >/dev/null; then
        echo "[*] Changes detected in /etc/group"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/group /etc/group
    fi

# /etc/hosts
    if ! diff -q "/limon/backup/etc/hosts" "/etc/hosts" >/dev/null; then
        echo "[*] Changes detected in /etc/hosts"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/hosts /etc/hosts
    fi

# /etc/resolv.conf
    if ! diff -q "/limon/backup/etc/resolv.conf" "/etc/resolv.conf" >/dev/null; then
        echo "[*] Changes detected in /etc/resolv.conf"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/resolv.conf /etc/resolv.conf
    fi

# /etc/sudoers
    if ! diff -q "/limon/backup/etc/sudoers" "/etc/sudoers" >/dev/null; then
        echo "[*] Changes detected in /etc/sudoers"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/sudoers /etc/sudoers
    fi

# /etc/ssh/sshd_config
    if ! diff -q "/limon/backup/etc/ssh/sshd_config" "/etc/ssh/sshd_config" >/dev/null; then
        echo "[*] Changes detected in /etc/ssh/sshd_config"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/ssh/sshd_config /etc/ssh/sshd_config
    fi

# etc/sysctl.conf
    if ! diff -q "/limon/backup/etc/sysctl.conf" "/etc/sysctl.conf" >/dev/null; then
        echo "[*] Changes detected in /etc/sysctl.conf"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/sysctl.conf /etc/sysctl.conf
    fi

# etc/logrotate.conf
    if ! diff -q "/limon/backup/etc/logrotate.conf" "/etc/logrotate.conf" >/dev/null; then
        echo "[*] Changes detected in /etc/logrotate.conf"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/logrotate.conf /etc/logrotate.conf
    fi

# etc/crontab
    if ! diff -q "/limon/backup/etc/crontab" "/etc/crontab" >/dev/null; then
        echo "[*] Changes detected in /etc/crontab"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/crontab /etc/crontab
    fi

# etc/apt/sources.list
    if ! diff -q "/limon/backup/etc/apt/sources.list" "/etc/apt/sources.list" >/dev/null; then
        echo "[*] Changes detected in /etc/apt/sources.list"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/apt/sources.list /etc/apt/sources.list
    fi

# /etc/network/interfaces
    if ! diff -q "/limon/backup/etc/network/interfaces" "/etc/network/interfaces" >/dev/null; then
        echo "[*] Changes detected in /etc/network/interfaces"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/network/interfaces /etc/network/interfaces
    fi

# # /etc/bash/bash.bashrc
#     if ! diff -q "/limon/backup/etc/bash.bashrc" "/etc/bash.bashrc" >/dev/null; then
#         echo "[*] Changes detected in /etc/bash.bashrc"
#         echo "-------------------------------"
#         diff --color=auto /limon/backup/etc/bash.bashrc /etc/bash.bashrc
#     fi

# /etc/profile
    if ! diff -q "/limon/backup/etc/profile" "/etc/profile" >/dev/null; then
        echo "[*] Changes detected in /etc/profile"
        echo "-------------------------------"
        diff --color=auto /limon/backup/etc/profile /etc/profile
    fi
}

# Generates output
generate_output(){
    echo "[*] Generating output..."

    # Checks whether the output folder exists, if not it creates the path
    output_dir="/limon/outputs/"
    if [ ! -d "$output_dir" ]; then
        mkdir "$output_dir"
    fi

    # Sets up log file name
    log_file="/limon/outputs/$(date +"%Y_%m_%d_%H_%M_%S").log"
    touch "$log_file"

    # Pipes the output of the check function into the log file
    check_integrity | tee "$log_file"
    echo "[*] Report saved to $log_file"
}

while getopts ":hpirco" option; do
    case "${option}" in
        h) show_help;;
        p) rotate_info;;
        i) setup_integrity;;
        r) restore_integrity;;
        c) check_integrity;;
        o) generate_output;;
        *) echo "[X] Invalid option: -${OPTARG}" >&2; show_help;;
    esac
done