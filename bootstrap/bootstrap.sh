# Run me like this (you really do need curl -- wget doesn't like github's wildcard cert)_
# curl https://github.com/36Zeroes/chef/raw/master/bootstrap/bootstrap.sh | sudo sh

# BOOTSTRAP CHEF INSTALL
echo "Adding opscode repository..."
echo 'deb http://apt.opscode.com/ lucid main' |  tee /etc/apt/sources.list.d/opscode.list
  wget -qO - http://apt.opscode.com/packages@opscode.com.gpg.key |  apt-key add -


echo "Updating package list.."
  apt-get update

echo "Installing chef.."
  apt-get install chef --force-yes -y
echo "done."
echo ""

# Disable chef-client running, coz we do chef-solo
echo "Stopping chef-client as chef-solo is all thats used..."
  service chef-client stop
echo "Disabling chef-client from boot..."
  update-rc.d chef-client disable
echo "done."
echo ""

# CHECKOUT COOKBOOKS from 36Zeroes Chef
  apt-get install git-core --force-yes -y
echo "Putting 36 Zeroes chef repo at /var/chef..."
  mkdir /var/chef
  git clone https://36Zeroes@github.com/36Zeroes/chef.git /var/chef
  cd /var/chef
  git submodule init
  git submodule update
echo "done."
echo ""

# Symlink the config
  ln -s /var/chef/bootstrap/solo.rb /etc/chef/solo.rb
echo "Linked /etc/chef/solo.rb -> /var/chef/bootstrap/solo.rb"
  ln -s /var/chef/clients /etc/chef/clients
echo "Linked /etc/chef/clients/ -> /var/chef/clients/"
echo ""

# Run bootstrap chef-solo
echo "To run, use your client node name, like so:"
echo " chef-solo -j /etc/chef/clients/kirra/reporting.json"

