#!/usr/bin/env bash

echo "Prepare folders..."

echo "Create apps folder under home for all installed apps"
sudo mkdir -p /home/apps
sudo chmod -R 777 /home/apps

echo "To remove libreoffice apps:"

sudo apt-get remove -y --purge libreoffice*
sudo apt-get -y clean
sudo apt-get -y autoremove

echo "To remove firefox:"
sudo apt-get purge firefox firefox-globalmenu -y


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

#echo "Install netbeans 8.2 at /home/apps/"

#wget download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-linux.sh
#chmod +x netbeans-8.2-linux.sh
#./netbeans-8.2-linux.sh --javahome /usr/lib/jvm/java-8-oracle 

echo "Install google chrome..."

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt-get update
sudo apt-get install google-chrome-stable -y

echo "Remove the added google list"
sudo rm -rf /etc/apt/sources.list.d/google.list

echo "Install mysql server "
echo "Issuing "
echo "mysqladmin -u root -p version"
echo "To see if it is working or not" 
debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123456'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123456'
apt-get update
apt-get install -y mysql-server

#echo "Install php7, to verify type"
#echo "php -v"

#sudo add-apt-repository ppa:ondrej/php	
#sudo apt-get update
#sudo apt-get -y install php7.0-cli php7.0-common libapache2-mod-php7.0 php7.0 php7.0-mysql php7.0-fpm php7.0-curl 

#echo "Install phpmyadmin, to verify type in browser"
#echo "http://localhost/phpmyadmin/"
#sudo apt-get -y install phpmyadmin








