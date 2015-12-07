########################################################################
#
# quick provisioning script for weewx-3.2.1 on debian-8 under vagrant
#    2015-1206 - vinceskahan@gmail.com - weewx 3.3.1 with US debian mirrors
#    2015-1206 - vinceskahan@gmail.com - weewx 3.3.0 with US debian mirrors
#    2015-0814 - vinceskahan@gmail.com - weewx 3.2.1 with US debian mirrors
#
########################################################################

# set to USA debian mirrors (my base box used UK)
cp /vagrant/sources.list /etc/apt/sources.list

# patch up to current
sudo apt-get update

# this slows my dev cycle down too much
# sudo apt-get upgrade

# get ancillary stuff not in the base box
sudo apt-get install -y sqlite3 lynx wget curl procps nginx ntp

# get weewx prerequisites
sudo apt-get install -y python-configobj python-cheetah python-imaging python-serial python-usb python-dev

# optional - this will slow your install down
# sudo apt-get install -y python-pip
# sudo pip install pyephem

#-------------------------------
# uncomment your desired method to download weewx sources

# DOWNLOAD_METHOD="git"             # bleeding edge
DOWNLOAD_METHOD="prepackaged"       # official version

#-------------------------------

echo "...downloading weewx..."
if [ "x${DOWNLOAD_METHOD}" = "xgit" ]
then
   sudo apt-get install -y git
   git clone https://github.com/weewx/weewx.git /tmp/weewx-current
else
   # this assumes Tom always has his tarball with a top directory weewx-x.y.z
   wget http://www.weewx.com/downloads/weewx-3.3.1.tar.gz -O /tmp/weewx.tgz
   echo "...extracting weewx..."
   cd /tmp
   tar zxf /tmp/weewx.tgz
fi

echo "...building weewx (simulator mode)..."
cd /tmp/weewx-* ; ./setup.py build ; sudo ./setup.py install --no-prompt

# link it into the web (debian)
# IMPORTANT: the path might be different on ubuntu
sudo  ln -s /var/www/html /home/weewx/public_html

# put system startup file into place
sudo cp /home/weewx/util/systemd/weewx.service /etc/systemd/system

# patching/fixing is not needed as of 3.2.0
# sudo cp /vagrant/weewx.service /etc/systemd/system

# put 'our' weewx.conf into place (enables debug=1)
sudo cp /vagrant/weewx.conf /home/weewx/weewx.conf

# enable the service
sudo systemctl enable weewx

# light that candle
sudo systemctl start weewx

