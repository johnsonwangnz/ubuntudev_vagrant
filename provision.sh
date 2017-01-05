#!/usr/bin/env bash



echo "Install apache server..."
sudo apt -y install apache2


echo "To remove libreoffice apps:"

sudo apt-get remove -y --purge libreoffice*
sudo apt-get -y clean
sudo apt-get -y autoremove

echo "Create shared folder under /vagrant"

mkdir -p /vagrant/shared

echo "Create published wwww folder under /vagrant/shared"

mkdir -p /vagrant/shared/wwwroot

echo "Create a sample published folder for Test1 under /vagrant/shared/Test1 using symbolic link"
echo "Aftert this you can visit 192.168.56.2/Test1/index.html"

mkdir -p /vagrant/shared/wwwroot/Test1
sudo ln -s /vagrant/shared/wwwroot/Test1 /var/www/html/Test1
cp /var/www/html/index.html /var/www/html/Test1/index.html
