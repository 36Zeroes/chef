# BOOTSTRAP CHEF INSTALL
echo 'deb http://apt.opscode.com/ lucid main' | sudo tee /etc/apt/sources.list.d/opscode.list
wget -qO - http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install chef -y

# Disable chef-client running, coze we do chef-solo
sudo service chef-client stop
sudo update-rc.d chef-client disable


# CHECKOUT COOKBOOKS from 36Zeroes Chef
sudo apt-get install git-core -y
sudo mkdir /var/chef
sudo git clone https://36Zeroes@github.com/36Zeroes/chef.git  /var/chef

# Copy initial config to chef-default
sudo cp /var/chef/bootstrap/solo.rb /etc/chef/solo.rb

# Run bootstrap chef-solo
#sudo chef-solo -j /var/chef/clients/kirra/linux.json


