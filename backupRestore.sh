#Paul lawlor
#Software Installation
#Backup and restore
#!/bin/bash

#compressFile()
#{
#   if [[ -e $# ]]; then
#      tar cvf $#.tgz $#
#      echo "The file " $# " has been compressed"
#   fi
#
#}


get_path() {

	temp_path=$#

	if [ "$temp_path" != "" ]; then
		read -p "Enter the ABSOLUTE path for the backup to be stored " path;
		echo "$path";

	fi
}


fullBackup(){

	get_path $location;

	echo $location >> excludelist.txt;

	if [[ -e $location ]]; then
	echo "Compressing....";

        tar cvpzf $location.tgz $location
        echo "The file " $location " has been compressed"
        fi


	echo "Starting backup.....";
    	rsync -avzhe ssh --progress --delete --max-size='10000k' --exclude-from 'excludelist.txt' /home/network/git-repos/SoftwareInstall $path;
    	echo -e "\nBackup complete!";



}

while :
do
clear
echo "##################################################"
echo "Main menu"
echo "##################################################"
echo "1)Full Backup:"
echo "2)Incremental Backup:"
echo "3)Shedule Backup:"
echo "4)Restore Most recent backup:"
echo "5)Exit backup:"
echo "=================================================="
echo "Choose an option from menu: "

read choice

case $choice in

1)fullBackup;read;;
2)incrementalBackup;read;;
3)sheduleBackup;read;;
4)restoreMostRecentBackup;read;;
5)exitBackup;read;;

*)echo "Please enter a vald option: a number from 1-6";
echo "Press a key.....";read;;
esac
done
