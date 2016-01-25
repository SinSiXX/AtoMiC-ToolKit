#!/bin/bash
# Script Name: AtoMiC CouchPotato Backup Script
# Author: htpcBeginner
# Publisher: http://www.htpcBeginner.com
# License: MIT License (refer to README.md for more details)
#

# DO NOT EDIT ANYTHING UNLESS YOU KNOW WHAT YOU ARE DOING.

if [[ $ISSETUP != "Yes" ]]
then
  echo
  echo -e '\e[91mCannot be run directly. Please run setup.sh from AtoMiC ToolKit root folder: \033[0msudo bash setup.sh'
  echo
  exit 0
fi
source $SCRIPTPATH/inc/commons.sh
source $SCRIPTPATH/inc/header.sh

APPNAME='couchpotato'
APPPATH='/home/'$UNAME'/.couchpotato'

echo -e $GREEN'AtoMiC CouchPotato Backup Script'$ENDCOLOR

source $SCRIPTPATH/inc/pause.sh

if [ ! -d "$APPPATH" ]; 
then
	echo -e $RED'Error! '$CYAN$APPPATH$RED' not found. CouchPotato not installed or incompatible installation.'$ENDCOLOR
    source $SCRIPTPATH/inc/pause.sh
    source $SCRIPTPATH/inc/couchpotato-menu.sh
fi

echo -e $YELLOW'--->Creating a list of files to backup...'$ENDCOLOR
cp $SCRIPTPATH/couchpotato/couchpotato-backup-files $SCRIPTPATH/tmp/cp-backup-files
sudo sed -i 's/UNAME/'$UNAME'/g' $SCRIPTPATH/tmp/cp-backup-files  || { echo -e $RED'Replacing username in backup list failed.'$ENDCOLOR ; exit 1; }

echo
sleep 1

echo -e $YELLOW'--->Backing up files...'$ENDCOLOR
BFN=couchpotato_`date '+%m-%d-%Y_%H-%M'`
tar -zcvf $SCRIPTPATH/tmp/$BFN.tar.gz --ignore-failed-read --files-from $SCRIPTPATH/tmp/cp-backup-files
echo
echo -e $GREEN"All files / folders present from the following list were backed up:"$ENDCOLOR
cat $SCRIPTPATH/tmp/cp-backup-files
rm $SCRIPTPATH/tmp/cp-backup-files

echo
sleep 1
echo

echo -e $YELLOW'--->Moving backup file to '$CYAN$SCRIPTPATH'/backups/'$BFN'.tar.gz...'$ENDCOLOR
mv $SCRIPTPATH/tmp/$BFN.tar.gz $SCRIPTPATH/backups/
sudo chown $UNAME:$UGROUP $SCRIPTPATH/backups/$BFN.tar.gz
sudo chmod 755 $SCRIPTPATH/backups/$BFN.tar.gz

sleep 1

echo
echo -e $GREEN'--->All done. '$ENDCOLOR
echo -e 'CouchPotato files backed up. You can use the restore utility to restore it on a new computer.'

source $SCRIPTPATH/inc/thankyou.sh
source $SCRIPTPATH/inc/exit.sh
