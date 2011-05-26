# Run me like this: 
# You really do need curl -- wget doesn't like github's wildcard cert
# sudo su
# curl https://github.com/36Zeroes/chef/raw/master/bootstrap/bootstrap.sh | sh

# BOOTSTRAP CHEF INSTALL
echo "Adding opscode repository..."
echo 'deb http://apt.opscode.com/ lucid main' | sudo tee /etc/apt/sources.list.d/opscode.list
wget -qO - http://apt.opscode.com/packages@opscode.com.gpg.key | sudo apt-key add -

echo "Updating package list.."
sudo apt-get update

echo "Installing chef.."
sudo apt-get install chef -y
echo "done."
echo ""

# Disable chef-client running, coze we do chef-solo
echo -n "Disabling chef-client as chef-solo is all thats used..."
sudo service chef-client stop
sudo update-rc.d chef-client disable
echo "done."

# CHECKOUT COOKBOOKS from 36Zeroes Chef
sudo apt-get install git-core -y
echo -n "Putting 36 Zeroes chef repo at /var/chef..."
sudo mkdir /var/chef
sudo git clone https://36Zeroes@github.com/36Zeroes/chef.git  /var/chef
echo "done."

# Symlink the config
sudo ln -s /var/chef/bootstrap/solo.rb /etc/chef/solo.rb
echo "Linked /etc/chef/solo.rb -> /var/chef/bootstrap/solo.rb"
sudo ln -s /var/chef/clients /etc/chef/clients
echo "Linked /etc/chef/clients/ -> /var/chef/clients/"

# Run bootstrap chef-solo
echo "To run, use your client node name, like so:"
echo "sudo chef-solo -j /etc/chef/clients/kirra/reporting.json"


