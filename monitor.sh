#! /bin/bash
if [[ $EUID -ne 0 ]]
then
    printf 'Must be run as root, exiting!\n'
    exit 1
fi

# Take in arguments
show_help() {
    # Display a banner
    figlet "LiMon Debian" -c
    echo ""
    echo "Usage: $0 [-h] [-p] [-i] [-o]"
    echo ""
    echo "Options:"
    echo "-h  Print this help message"
    echo "-p  Periodically display system info"
    echo "-i  Set up for an integrity check"
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
        echo "ACTIVE NETWORK CONNECTIONS:"
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

        # Display information about current login sessions
        echo "CURRENT LOGIN SESSIONS:"
        echo "-----------------------"
        w
        echo

        # Display information about recent login sessions
        echo "RECENT LOGIN SESSIONS:"
        echo "----------------------"
        last | head -n5
        sleep 5
        clear

        # Display information about aliases defined in the shell
        echo "ALIASES:"
        echo "--------"
        
        touch /tmp/aliases
        alias >> /tmp/aliases
        cat /tmp/aliases

        echo
        sleep 5
        clear

        # Display information about aliases defined in the shell
        echo "USERS ABLE TO LOGIN:"
        echo "--------------------"
        grep -v -e "/bin/false" -e "/sbin/nologin" /etc/passwd | cut -d ':' -f1
        sleep 5
        clear
    done
}

while getopts ":hpio" option; do
    case "${option}" in
        h) show_help;;
        p) rotate_info;;
        i) echo "Set up for an integrity check";;
        o) echo "Output to /limon/outputs/YYYY_MM_DD_HH_MI.log";;
        *) echo "Invalid option: -${OPTARG}" >&2; show_help;;
    esac
done
# Require at least one argument
if [[ $# -lt 2 ]]; then
    echo "At least one argument is required"
    echo ""
    show_help
fi
shift $((OPTIND-1))


# Maximize the terminal window
wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz