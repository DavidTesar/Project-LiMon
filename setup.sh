#! /bin/bash
if [[ $EUID -ne 0 ]]
then
    printf 'Must be run as root, exiting!\n'
    exit 1
fi

if ! command -v gnome-terminal &> /dev/null; then
    read -p "gnome-terminal is not installed. Do you want to proceed with installation? [y/n]: " choice
    case "$choice" in y|Y )
        echo "Downloading gnome-terminal..."
        sudo apt-get update
        sudo apt-get install -y gnome-terminal
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

echo "[+] all necessary software present"