
#Paul lawlor
#Software Installation
#Backup and restore
#This script uses rsync and cron to back up the linux file system 
#the main menu has options which allow the user to choose which type of backup they want
#if the user chooses the option for a sheduled backup another menu will pop up
#which will offer the user the option of how frequently they would like to backup 
#their system.


#!/bin/bash


#getPath function takes in the path of the files to be backed up as an argument from the user 
getPath() {

	temp_path=$#

	if [ "$temp_path" != "" ]; then
		read -p "Enter the path where the backup is to be stored " path;
		echo "$path";

	fi
}

#fullBackup function uses rsync to backup and compress the file path and backs up to the chosen url 
fullBackup(){

	#stores the path passed in in a variable
	getPath $path;

	#This adds the path to the exclude list 
	echo $path >> excludedLocations.txt;
	make a backup directory just in case it's not there already
        mkdir -p $path;
		
	echo "Starting backup.....";
	#rsync options -a archive, -verbose, -z compress, h human readable
	#-e specify remote shell,-p preserve permissions, -t preserve modification times
	# --delete delete from target directory if it's deleted from  source
	# --progress during trandfer,  
    	rsync -avzhep ssh --progress --delete --exclude-from 'excludedLocations.txt' /home/network $path;

   	echo -e "Backup complete, Press Enter:";

}

#incrementalBackup function uses rsync to backup only the files which have changed 
incrementalBackup(){

	#stores the path in a variable
	getPath $path;
	#make a backup directory just in case it's not there already
        mkdir -p $path;

	#add the path to the excluded file
        echo $path >> excludedLocations.txt;

        echo "Starting backup.....";
        #rsync options -a archive, -verbose, -z compress, h human readable
        #-e specify remote shell,-p preserve permissions, -t preserve modification times
        # --delete delete from target directory if it's deleted from  source
        # --progress during transfer,-b make backup into hierarchy
        rsync -abvzhep ssh --progress --delete --exclude-from 'excludedLocations.txt' /home/network $path
        echo -e "Incremental Backup complete, Press Enter:";

}

# addCronTab function adds the cron job to the cron table
addCronTab()
{
	crontab -l | { cat; echo "$1 rsync -avbzhe  --delete --progress  --exclude-from 'excludedLocations.txt' /home/network/backup"; } | crontab -;
}


#dailyBackup function uses cron jobs to shedule backups every day
dailyBackup(){

	#stores the path passed in in a variable
	getPath $path;

	#adds the path to the excluded file
        echo $path >> excludedLocations.txt;

	#make a backup directory just in case it;s not there already
        mkdir -p $path;

	#Runs daily at midnight
	addCronTab @daily;
	echo "Daily crontab added now backing up folder / to location $path";
	echo "Press enter:"
	break;

}

#weeklyBackup function uses cron jobs to shedule backups every week
weeklyBackup(){

	#store path in a variable
        getPath $path;

	#add the path to the excluded list
        echo $path >> excludedLocations.txt;

	#make a backup directory just incase it's not there already

	#Runs once a week at midnight on a Sunday morning
	mkdir -p $path;
        addCronTab @weekly;
        echo "Weekly crontab added now backing up folder / to location $path";
        echo "Press enter:"
	break;

}

#monthlyBackup function uses cron jobs to shedule backups every month
monthlyBackup(){

	#store path in a variable
        getPath $path;

	#add the path to the excluded list
        echo $path >> excludedLocations.txt;

	#make a backup directory just incase it's not there already
        mkdir -p $path;

	#Runs once amonth at midnight on 1st day of month 
        addCronTab @monthly;
        echo "Monthly crontab added now backing up folder / to location $path";
        break;

}

#annualBackup function uses cron jobs to shedule backups every year
annualBackup(){

	#store path in a variable
        getPath $location;

	#add the path to the excluded list
        echo $location >> excludedLocations.txt;

	#make a backup directory just incase it's not there already
        mkdir -p $location;

	#runs once a year at midnight on Jan 1st
        addCronTab @annualy;
        echo "Annual crontab added now backing up folder / to location $path";
        break;

}

#restoreBackup function uses pull request with rsync to restore most recent backup
#from backup location 
restoreBackup(){

	#store path in a variable
	getPath $path;

	#rsync pull request to restore from last  backup
	echo "Restoring file from last known backup....";
	rsync -abvzhe --progress --delete --exclude-from 'excludedLocations.txt' $path /home/network ;
	echo "Last known backup restored";

}

#sheduleBackup function uses a case statement to bring up a menu 
#so the user can choose the frequency of backups
sheduleBackup(){

	while :
	do
	clear
	echo "###############################################################"
	echo "Please enter how frequently you would like to backup the system"
	echo "###############################################################"
	echo "1)Daily:"
	echo "2)Weekly:"
	echo "3)Monthly:"
	echo "4)Annualy:"
	echo "5)Exit menu:"
	echo "==============================================================="
	echo "Choose an option from menu: "

	read choice

	case $choice in

	1)dailyBackup;read;;
	2)weeklyBackup;read;;
	3)monthlyBackup;read;;
	4)annualBackup;read;;
	5)exit 0;;
	*)echo "Please enter a vald option: a number from 1-5";
	echo "Press a key.....";read;;
	esac
	done

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
4)restoreBackup;read;;
5)exit 0;;

*)echo "Please enter a vald option: a number from 1-6";
echo "Press a key.....";read;;
esac
done
