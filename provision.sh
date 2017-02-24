#!/usr/bin/env bash

#stop on error
set -e
echo "If there was a problem, please correct and destroy and start provision process again, as the script only suppose to be run once..."

#to remove a package 
#sudo apt-get --purge remove packagename
echo "Define some variables"
DBPASSWD=123456

echo "Set timezone instead of using UTC"
echo  'Pacific/Auckland' | sudo tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

echo "Prepare folders..."

echo "Create apps folder under home for all installed apps"
sudo mkdir -p /home/apps
sudo chmod -R 777 /home/apps

echo "Prepare environment variables"
source ~/.bashrc && [ -z "$SPARK_HOME" ] && echo "export SPARK_HOME=/usr/local/spark" >> ~/.bashrc


echo "To remove libreoffice apps:"

sudo apt-get remove -y --purge libreoffice*
sudo apt-get -y clean
sudo apt-get -y autoremove

#echo "To remove firefox:"
#sudo apt-get purge firefox firefox-globalmenu -y

#echo "Install google chrome..."

#wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
#sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

#sudo apt-get update
#sudo apt-get install google-chrome-stable -y

#echo "Remove the added google list"
#sudo rm -rf /etc/apt/sources.list.d/google.list


echo "Install java8"
echo "If it hangs at setting grub-pc, please run:"
echo "sudo dpkg --configure -a"
echo "After restart the vagrant with no provision(comment it out) and vagrant ssh "

sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get -y upgrade
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get -y install oracle-java8-installer

#echo "Install netbeans 8.2 at /home/apps/, this has to be done in GUI"
echo "Must change java home as netbeans installer does not detect "
echo "The default place it is installed to is /usr/local/netbeans-8.2"
#wget download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh
#chmod +x netbeans-8.2-linux.sh
#./netbeans-8.2-linux.sh --javahome /usr/lib/jvm/java-8-oracle 

#install eclipse

if [ ! -d "/opt/eclipse" ]; then

	echo "Install eclipse"

	wget "http://eclipse.bluemix.net/packages/neon.2/data/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz"
	tar -xzvf eclipse-java-neon-2-linux-gtk-x86_64.tar.gz
	sudo mv eclipse /opt/eclipse
	rm eclipse-java-neon-2-linux-gtk-x86_64.tar.gz

	sudo ln -s /opt/eclipse/eclipse /usr/local/bin

fi

echo "Install apache server..."
sudo apt -y install apache2

if [! -d "/vagrant/shared" ]; then

	echo "Create shared folder under /vagrant"

	mkdir -p /vagrant/shared

	echo "Create published wwww folder under /vagrant/shared"

	mkdir -p /vagrant/shared/wwwroot

	echo "Create a sample published folder for Test1 under /vagrant/shared/Test1 using symbolic link"
	echo "Aftert this you can visit 192.168.56.2/Test1/index.html"

	mkdir -p /vagrant/shared/wwwroot/Test1
	sudo ln -s /vagrant/shared/wwwroot/Test1 /var/www/html/Test1
	cp /var/www/html/index.html /var/www/html/Test1/index.html

	echo "Remove the symbolic link"

	unlink /var/www/html/Test1


	echo "Remove the test folder"
	rm -rf /vagrant/shared/wwwroot/Test1

fi

echo "Install php5, to verify type"
echo "php -v"

sudo apt-get -y install php5


echo "Install mysql server "
echo "Issuing "
echo "mysqladmin -u root -p version"
echo "To see if it is working or not"

echo "mysql-server-5.6 mysql-server/root_password password $DBPASSWD" | sudo debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password $DBPASSWD" | sudo debconf-set-selections

sudo apt-get -y install mysql-server-5.6

sudo apt-get install -y php5-mysql

sudo service apache2 restart

echo "Install phpmyadmin, to verify type in browser"
echo "http://localhost/phpmyadmin/"

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | sudo debconf-set-selections

#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
#sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

sudo apt-get -y install phpmyadmin

echo "Install xdebug..."
echo "The actuall version of xdebug will be echoed in console"

sudo apt-get -y install php5-dev php-pear
#sudo pecl install xdebug
sudo apt-get install php5-xdebug

echo "Modify the config file for php.ini or dir for additional .ini files , find its place at http://localhost/index.php"
echo "Please manually add following to xdebug.ini to above dir "
echo "; xdebug debugger"
echo "zend_extension='/usr/lib/php5/20121212/xdebug.so'"
echo "xdebug.remote_enable = 1"
echo "xdebug.remote_connect_back = 1"
echo "after that restart apache server: service apache2 restart"


echo "Install git and git gui"
sudo apt-get -y install git
sudo apt-get -y install git-gui

echo "Install nodejs 7, run node or nodejs -v to check versions "
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "Install R "
	
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install r-base-dev

echo "Install maven"
sudo apt-get -y install maven	

echo "Install docker :"
echo "Issuing following to check docker version"
echo "sudo docker --version"
sudo wget -qO- https://get.docker.com/ | sh

echo "Install docker composer"
echo "Add current user to docker group"

sudo usermod -aG docker $(whoami)

echo "Install Python-pip"
sudo apt-get -y install python-pip

echo "Install docker-compose"
echo "Verify : docker-compose --version"
sudo pip install docker-compose 

#install spark
echo "Checking spark folder..."
if [ ! -d "/usr/local/spark" ]; then
	echo "Install spark-2.1.0"
	wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
	tar -xzvf  spark-2.1.0-bin-hadoop2.7.tgz
	sudo mv spark-2.1.0-bin-hadoop2.7 /usr/local/spark
	rm spark-2.1.0-bin-hadoop2.7.tgz
fi



# Add hadoop hosts names to local hosts
if ! grep -q "hadoop-master" /etc/hosts 
then
	echo '172.18.0.2 hadoop-master' | sudo tee --append /etc/hosts
fi

if ! grep -q "hadoop-slave1" /etc/hosts 
then
	echo '172.18.0.3 hadoop-slave1' | sudo tee --append /etc/hosts
fi

if ! grep -q "hadoop-slave2" /etc/hosts 
then
	echo '172.18.0.4 hadoop-slave2' | sudo tee --append /etc/hosts
fi


#Fix docker compose build error:  module object has no attribute connection
echo "Do following to avoid docker compose build error:  module object has no attribute connection"
sudo pip install --upgrade pip && pip install -U urllib3

echo "Checking mydocker folder..."
if [ ! -d "/home/vagrant/mydocker" ]; then
	#Get big data dev docker files
	echo "Git clone bddevdocker docker files"
	mkdir mydocker
	cd mydocker
	git clone https://github.com/johnsonwangnz/bddevdocker.git
	cd /home/vagrant
fi


echo "Sucecessfully Finished provisioning of vagrant."
echo "vagrant ssh to start using."








