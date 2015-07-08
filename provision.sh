########################################################################
#
# quick provisioning script for weewx-3.1.0 on debian-8 under vagrant
#    2015-0522 - vinceskahan@gmail.com - original
#
########################################################################

# patch up to current
sudo apt-get update

# uncomment to update all packages to current (takes some time)
# sudo apt-get upgrade

# get ancillary stuff not in the base box
sudo apt-get install -y sqlite3 lynx wget curl procps nginx

# get weewx prerequisites
sudo apt-get install -y python-configobj python-cheetah python-imaging python-serial python-usb python-dev

# use git to grab weewx
sudo apt-get install -y git

# download/build/install weewx in simulator mode
git clone https://github.com/weewx/weewx.git /tmp/weewx
cd /tmp/weewx
sudo ./setup.py build
sudo ./setup.py install --no-prompt

# link it into the web (debian) - the path is different on ubuntu
sudo ln -s /var/www/html /home/weewx/public_html

# put upstream config file into place
sudo cp /tmp/weewx/util/systemd/weewx.service /etc/systemd/system

# similarly put 'our' weewx.conf into place (enables debug=1)
# sudo cp /vagrant/weewx.conf /home/weewx/weewx.conf
sudo cp /home/weewx/weewx.conf /tmp/weewx.conf
sudo sed -e s:debug\ =\ 0:debug\ =\ 1: < /tmp/weewx.conf > /home/weewx/weewx.conf

# enable the service
sudo systemctl enable weewx

# light that candle
sudo systemctl start weewx

