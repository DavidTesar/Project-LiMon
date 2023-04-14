#! /bin/bash
if [[ $EUID -ne 0 ]]
then
    printf 'Must be run as root, exiting!\n'
    exit 1
fi

if ! command -v neofetch &> /dev/null; then
    read -p "neofetch is not installed. Do you want to proceed with installation? [y/n]: " choice
    case "$choice" in y|Y )
        echo "Downloading neofetch..."
        sudo apt-get install -y neofetch
        ;;
        
        n|N ) 
        echo "Exiting script."
        exit 1
        ;;

        * ) 
        echo "Invalid input. Exiting script."
        exit 1
        ;;
    esac
fi

if ! command -v tripwire &> /dev/null; then
    read -p "tripwire is not installed. Do you want to proceed with installation? [y/n]: " choice
    case "$choice" in y|Y )
        echo "Downloading tripwire..."
        sudo apt-get install -y tripwire
        ;;
        
        n|N ) 
        echo "Exiting script."
        exit 1
        ;;

        * ) 
        echo "Invalid input. Exiting script."
        exit 1
        ;;
    esac
fi

if ! command -v figlet &> /dev/null; then
    read -p "tripwire is not installed. Do you want to proceed with installation? [y/n]: " choice
    case "$choice" in y|Y )
        echo "Downloading figlet..."
        sudo apt-get install -y figlet toilet
        ;;
        
        n|N ) 
        echo "Exiting script."
        exit 1
        ;;

        * ) 
        echo "Invalid input. Exiting script."
        exit 1
        ;;
    esac
fi

echo "[+] all necessary software present"