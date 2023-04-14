if [[ $EUID -ne 0 ]]
then
    printf 'Must be run as root, exiting!\n'
    exit 1
fi

neofetch
sleep 5

twadmin --create-polfile /etc/tripwire/tw.pol
tripwire --init


find / -name .bashrc > temp4 &
md5sum /etc/passwd /etc/group /etc/profile md5sum /etc/sudoers /etc/hosts /etc/ssh/ssh_config /etc/ssh/sshd_config > temp2
ls -a /etc/ /usr/ /sys/ /home/ /bin/ /etc/ssh/ >> temp2
while true;
do	
	netstat -n -A inet | grep ESTABLISHED > temp
	incoming_ftp=$(cat temp | cut -d ':' -f2 | grep "^21" | wc -l)
	outgoing_ftp=$(cat temp | cut -d ':' -f3 | grep "^21" | wc -l)
	
	incoming_ssh=$(cat temp | cut -d ':' -f2 | grep "^22" | wc -l)
	outgoing_ssh=$(cat temp | cut -d ':' -f3 | grep "^22" | wc -l)	

	outgoing_telnet=$(cat temp | cut -d ':' -f2 | grep "^23" | wc -l)
	incoming_telnet=$(cat temp | cut -d ':' -f3 | grep "^23" | wc -l)

	incoming_telnet=$(cat temp | cut -d ':' -f2 | grep "^^23" | wc -l)
	outgoing_telnet=$(cat temp | cut -d ':' -f3 | grep "^^23" | wc -l)

	
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
	cat temp
	sleep 5
	clear

	echo "CURRENT LOGIN SESSIONS:"
	echo "-----------------------"
	w
	echo
	echo "RECENT LOGIN SESSIONS:"
	echo "----------------------"
	last | head -n5
	sleep 5
	clear

	sleepingProcs=$(pstree | grep sleep)
	if [[ ! -z "$sleepingProcs" ]];then
	echo "SLEEP PROCESSES:"
	echo "----------------"
	sleep 5
	clear
	fi

	#Check for changes to important files.
	
    echo "CHANGE IN FILES"
    echo "--------"
    tripwire --check

	echo "ALIASES:"
	echo "--------"
	alias
	echo
	sleep 5
	clear

	echo "USERS ABLE TO LOGIN:"
	echo "--------------------"
	grep -v -e "/bin/false" -e "/sbin/nologin" /etc/passwd | cut -d ':' -f1
	sleep 5
	clear
done