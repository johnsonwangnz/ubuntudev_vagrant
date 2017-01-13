#!/usr/bin/env bash

#stop on error
#set -e

echo "Define some variables"
DBPASSWD=123456

echo "Prepare folders..."

echo "Create apps folder under home for all installed apps"
sudo mkdir -p /home/apps
sudo chmod -R 777 /home/apps

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

#wget download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh
#chmod +x netbeans-8.2-linux.sh
#./netbeans-8.2-linux.sh --javahome /usr/lib/jvm/java-8-oracle 



echo "Install apache server..."
sudo apt -y install apache2


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
update-alternatives --config Test1

echo "Remove the test folder"
rm -rf /vagrant/shared/wwwroot/Test1


echo "Install php5, to verify type"
echo "php -v"

sudo apt-get -y install php5



echo "Install mysql server "
echo "Issuing "
echo "mysqladmin -u root -p version"
echo "To see if it is working or not" 
debconf-set-selections <<< 'mysql-server mysql-server/root_password password $DBPASSWD'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $DBPASSWD'

sudo apt-get install -y mysql-server
sudo apt-get install -y php5-mysql

sudo service apache2 restart

echo "Install phpmyadmin, to verify type in browser"
echo "http://localhost/phpmyadmin/"

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

sudo apt-get -y install phpmyadmin

echo "Install xdebug..."
echo "The actuall version of xdebug will be echoed in console"

sudo apt-get -y install php5-dev php-pear
sudo pecl install xdebug

echo "Modify the config file for php.ini or dir for additional .ini files , find its place at http://localhost/index.php"
echo "Please manually add following to xdebug.ini to above dir "
echo "; xdebug debugger"
echo "zend_extension='/usr/lib/php5/20121212/xdebug.so'"
echo "xdebug.remote_enable = 1"
echo "xdebug.remote_connect_back = 1"


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
 

echo "Finished installing modules automatically,"
echo "If there was a problem, please issue following..."
echo "sudo apt-get --purge remove XXXXXX"







