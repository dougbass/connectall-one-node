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

export CATALINA_HOME=/ConnectAll/CATomcat

echo "Change to the /ConnectAll folder"
cd /ConnectAll

# Run the upgrade if the file exists
if [ -f /ConnectAll/mulesoft/upgrade.sh ]; then
  . /ConnectAll/mulesoft/.profile
  echo "Run the ConnectAll upgrade"
  cd /ConnectAll
  echo "Make all the script executable"
  chmod +x $1
  echo "Run the upgrade script"
  /ConnectAll/mulesoft/upgrade.sh -varfile /ConnectAll/connectall.varfile -q  -console   -Dinstall4j.keepLog=true   -Dinstall4j.logToStderr=true
   . ${HOME_PROFILE} && $MULE_HOME/bin/mule

else
# Do this once on a new install
  if [ ! -f $CATALINA_HOME/logs/ConnectAll.log ]; then
    echo "Change to the /ConnectAll folder"
    cd /ConnectAll

    if [ ! -f ConnectAll.sh ]; then
      wget -O ConnectAll.sh --user=connectall --password=C\$\$n3ct@11 http://downloads.go2group.com/CA/Release_2_9_0_patch3/doors/ConnectAll_Unix_2_9_0_Rf5e54eca_64.sh
    fi
    echo "Make all the script executable"
    chmod +x $1
    echo "Execute the installer"
    /ConnectAll/ConnectAll.sh -varfile /ConnectAll/connectall.varfile -q  -console   -Dinstall4j.keepLog=true   -Dinstall4j.logToStderr=true
    cp -v /ConnectAll/readme.html $CATALINA_HOME/webapps/ROOT/index.jsp
    cp -v ${HOME_PROFILE} /ConnectAll/mulesoft/.profile
    cp -v /ConnectAll/*.properties $MULE_HOME/conf
    cp -v /ConnectAll/*.json $CONNECTALL_HOME
   . ${HOME_PROFILE} && $MULE_HOME/bin/mule
  
  else
    . /ConnectAll/mulesoft/.profile
	set
	$CATALINA_HOME/bin/startup.sh
	$MULE_HOME/bin/mule
  fi

fi

