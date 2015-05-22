########################################################################
#
# quick provisioning script for weewx-3.1.0 on debian-8 under vagrant
#    2015-0522 - vinceskahan@gmail.com - original
#
########################################################################

# patch up to current
sudo apt-get update
sudo apt-get upgrade

# get ancillary stuff not in the base box
sudo apt-get install -y sqlite3 lynx wget curl procps nginx

# get weewx prerequisites
sudo apt-get install -y python-configobj python-cheetah python-imaging python-serial python-usb python-dev

# download/build/install weewx in simulator mode
wget http://sourceforge.net/projects/weewx/files/latest/download?source=files -O /tmp/weewx.tgz
cd /tmp
tar zxvf /tmp/weewx.tgz
cd weewx-* ; ./setup.py build ; sudo ./setup.py install --quiet

# link it into the web (debian) - the path is different on ubuntu
sudo  ln -s /var/www/html /home/weewx/public_html

# put upstream config file into place
sudo cp /home/weewx/util/systemd/weewx.service /etc/systemd/system

# then fix 3.1.0 by copying in a version that works on debian-8.0
sudo cp /vagrant/weewx.service /etc/systemd/system

# similarly put 'our' weewx.conf into place (enables debug=1)
sudo cp /vagrant/weewx.conf /home/weewx/weewx.conf

# enable the service
sudo systemctl enable weewx

# light that candle
sudo systemctl start weewx

