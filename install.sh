#!/bin/bash
date


#sleep 120
#while ! [ -f /var/lib/mysql/mysql ];
#do
# sleep 10
#done

echo start up MySql
cd /
service mysql start
#/usr/sbin/mysqld --user=mysql &
#sleep 60

echo Run the ConnectALL installer
date
#export JAVA_HOME=/usr/local/bin/java1.7/jdk1.7.0_79
export JAVA_HOME=/usr/local/bin/java1.7/jdk1.8.0_171
export PATH=$JAVA_HOME/bin:$PATH
export CATALINA_HOME=/ConnectAll/CATomcat
#export MULE_HOME=/ConnectAll/mulesoft/mule-standalone-3.6.1
export MULE_HOME=/ConnectAll/mulesoft/mule-standalone-3.9.0
export CONNECTALL_HOME=$MULE_HOME/database

echo "Change to the /ConnectAll folder"
cd /ConnectAll

# Run the upgrade if the file exists
if [ -f /ConnectAll/mulesoft/upgrade.sh ]; then
. /root/.bash_profile
  echo "Run the ConnectAll upgrade"
  cd /ConnectAll
  echo "Make all the script executable"
  chmod +x $1
  #chkconfig --add tomcat
  echo "Run the upgrade script"
  /ConnectAll/mulesoft/upgrade.sh -varfile /ConnectAll/connectall.varfile -q  -console   -Dinstall4j.keepLog=true   -Dinstall4j.logToStderr=true
#  sleep 60
#  $CATALINA_HOME/bin/shutdown.sh
else
# Do this once on a new install
  if [ ! -f $CATALINA_HOME/logs/ConnectAll.log ]; then
    echo "Change to the /ConnectAll folder"
    cd /ConnectAll
    echo "Make all the script executable"
    chmod +x $1
#    chkconfig --add tomcat
    echo "Execute the installer"
    /ConnectAll/ConnectAll.sh -varfile /ConnectAll/connectall.varfile -q  -console   -Dinstall4j.keepLog=true   -Dinstall4j.logToStderr=true
. /root/.bash_profile
#    sleep 60
#   /ConnectAll/set_mule_hostname.sh
#    /ConnectAll/CATomcat/bin/shutdown.sh
    #mv /ConnectAll /ConnectAll
    #cp -v /ConnectAll/*.properties $MULE_HOME/conf
    #cp -v /ConnectAll/*.json $CONNECTALL_HOME
    #service tomcat start
  fi
fi

# Do this everytime the container starts
. /root/.bash_profile
set
#  service tomcat restart
  $CATALINA_HOME/bin/startup.sh
  $MULE_HOME/bin/mule

#echo "Startup tomcat in the shell"
tail -f /dev/null
tail -f $CATALINA_HOME/logs/catalina.out
