#!/bin/bash/

echo "Enter your Password : "
read DB_Password

#colors
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#Date #ScriptName #Logfile
TIME_STAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo "$?" | cut -d "." -f1)
LOG_FILE=/tmp/$SCRIPT_NAME+$TIME_STAMP.log



#UserId
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]
then 
    echo -e "$R Please Provide SUDO access...$N"
    exit 1
else    
    echo -e "$G You are a Super user $N"
fi


VALIDATE ()
{
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 FAILURE $N"
        exit 1
    else    
        echo -e "$G $2 SUCCESS $N"
    fi
}


dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installation of mysql server : "

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling mysql : "

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Starting mysql : "


# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
# VALIDATE $? "Setting up password for mysql is  : "

## (mysql -h localhost -uroot -pExpenseApp@1 -e 'SHOW DATABASES;')

mysql -h db.happywithyogamoney.fun -uroot -p$(DB_Password) -e 'SHOW DATABASES;'
if [ $? -ne 0 ]
then 
    mysql_secure_installation --set-root-pass -p$(DB_Password) &>>$LOG_FILE
else 
    echo -e "$G You Already setup the Password for mySQL..so, we are skipping now .... $N"
fi


echo -e "$Y MySQL installation is Going GOOD $N" 