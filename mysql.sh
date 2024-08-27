#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0) | cut -d "." -f1
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAM.log"
mkdir -p $LOGS_FOLDER
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
CHECK_ROOT(){
    
if [ $USERID -ne 0 ]
 then 
    echo -e "$R please run this script with root priveleges $N" | tee -a $LOG_FILE
    exit 1
 fi

}

VALIDATE(){
if [  $1 -ne 0 ]

 then
     echo -e "$2 is...$R FAILED $N" | tee -a $LOG_FILE
     exit 1
 else 
     echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE

     fi
}

 echo "Script started executing at: $(date)" &>>$LOG_FILE | tee -a $LOG_FILE
 CHECK_ROOT

 dnf install mysql-server -y &>>$LOG_FILE
 VALIDATE $? "Installing Mysql Server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabled Mysql Server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Started Mysql Server"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
VALIDATE $? "Setting Up root password"
