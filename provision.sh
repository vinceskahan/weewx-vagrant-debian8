########################################################################
#
# quick provisioning script for weewx-3.2.1 on debian-8 under vagrant
#    2017-1013 - vinceskahan@gmail.com - weewx 3.8.0a0
#    2016-0314 - vinceskahan@gmail.com - weewx 3.5.0
#    2015-1212 - vinceskahan@gmail.com - set the timezone
#    2015-1206 - vinceskahan@gmail.com - weewx 3.3.1 with US debian mirrors
#    2015-1206 - vinceskahan@gmail.com - weewx 3.3.0 with US debian mirrors
#    2015-0814 - vinceskahan@gmail.com - weewx 3.2.1 with US debian mirrors
#
########################################################################

# uncomment to set the timezone to where we're at (edit to taste)
TIMEZONE="US/Pacific"
echo $TIMEZONE > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

# set to USA debian mirrors (my base box used UK)
cp /vagrant/sources.list /etc/apt/sources.list

# patch up to current
sudo apt-get update

# this slows my dev cycle down too much
# sudo apt-get upgrade

# get ancillary stuff not in the base box
sudo apt-get install -y sqlite3 lynx wget curl procps nginx ntp git

# get weewx prerequisites
sudo apt-get install -y python-configobj python-cheetah python-imaging python-serial python-usb python-dev

# optional - this will slow your install down
#    sudo apt-get install -y python-pip
#    sudo pip install pyephem

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
   wget  http://weewx.com/downloads/development_versions/weewx-3.8.0a1.tar.gz -O /tmp/weewx.tgz
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
#
#    my ansible provisioner is way slicker in doing this
#    as well as setting a 'lot' of weewx.conf config items
sudo cp /vagrant/weewx.conf /home/weewx/weewx.conf

# enable the service
sudo systemctl enable weewx


# influxdb
wget https://dl.influxdata.com/influxdb/releases/influxdb_1.3.6_amd64.deb
sudo dpkg -i influxdb_1.3.6_amd64.deb
systemctl enable influxdb
systemctl start influxdb

# minimal version of node
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

git clone https://github.com/tkeffer/weert-js.git
cd weert-js
cp weewx_extensions/weert.py /home/weewx/bin/user/weert.py
chmod 755 /home/weewx/bin/user/weert.py

# light that candle
sudo systemctl start weewx

npm install
npm start

npm install -g jasmine
# npm test


#--- this stuff should be done before starting weewx of course
# add stanza to stdrestful
####
#### [[WeeRT]]
####        host = localhost
####        port = 3000
####

# copy weert.py into bin/user
# chmod 755

# add to drivers
###[Engine]
###    [[Services]]
###        ...
###        restful_services = ..., user.weert.WeeRT
