#! /bin/bash
if [[ $EUID -ne 0 ]]
then
    printf 'Must be run as root, exiting!\n'
    exit 1
fi

show_help() {
    echo "Usage: $0 [-h]"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit."
    echo ""
    exit 0
}

while getopts "h-:" opt; do
    case "${opt}" in
        h)
            show_help
            ;;
        -)
            case "${OPTARG}" in
                help)
                    show_help
                    ;;
                *)
                    echo "Invalid option: --$OPTARG" >&2
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Maximize the terminal window
wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz

# Display a banner
figlet "LiMon Debian" -c

# Create a new Tripwire policy file and initialize Tripwire
twadmin --create-polfile /etc/tripwire/tw.pol
tripwire --init

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

	# Check for changes to important files using Tripwire
    echo "CHANGE IN FILES"
    echo "--------"
    tripwire --check

    # Display information about aliases defined in the shell
	echo "ALIASES:"
	echo "--------"
	alias
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