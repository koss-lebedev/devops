# 1. After AWS instance is launched, change security group's inbound roules
# to open HTTP and HTTPS ports

# 2. Create deployment user
sudo adduser deployer

# Add user to sud group
sudo vi /etc/sudoers

# Below sudo, add:
# deployer        ALL=(ALL:ALL) ALL

# To all password-less sudo commands used by Capistrano
deployer ALL=(ALL) NOPASSWD: ALL

# Switch to new user
su deployer

# 3. INSTALL RVM

# get RVM keys
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# change into writable directory
cd /tmp

# download and install RVM
curl -sSL https://get.rvm.io -o rvm.sh
cat /tmp/rvm.sh | bash -s stable --rails

# Source RVM as per post-install instructions
source /home/deployer/.rvm/scripts/rvm

# install required Ruby version
rvm install 2.2.2

# 4. INSTALL NODE.JS

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs

# 5. INSTALLING AND CONFIGURING NGINX

# Switch back to ubuntu user
exit

# Update apt packages and install NGINX
sudo apt-get update
sudo apt-get install nginx

# Update NGINX configuration file (see nginx.site.conf)
sudo vi /etc/nginx/sites-available/default

# restart NGINX
sudo service nginx restart

# 6. INSTALLING GEMS

# Make sur you have login session
bash --login

# install gems (use bundle show <gem> locally to get install versions)
gem install unicorn -v 5.1.0
gem install bundler -v 1.13.2

npm install -g mjml@3.3.3

sudo apt-get install imagemagick

# 7. CONFIGURE SSH ACCESS

# Login as deployer
su deployer

# generate SSH key pair without password
ssh-keygen -t rsa

# Copy the public key and add it to Bitbucket repo
vi ~/.ssh/id_rsa.pub

# Add local SSH key from development machine to remote server
sudo vi ~/.ssh/authorized_keys

# 8. CONFIGURE UNICORN

# create script (content in unicorn.sh)
sudo touch /etc/init.d/unicorn

# set permissions
sudo chmod 755 /etc/init.d/unicorn
sudo update-rc.d unicorn defaults

# 9. INSTALL POSTGRESQL

# install database server
sudo apt-get install postgresql postgresql-contrib

# install dev libs for building pg gem
sudo apt-get install libpq-dev

# log into psql console
sudo -u postgres psql postgres
# enter and confirm password
\password postgres
# create a DB
CREATE DATABASE dbname;
# exit psql
\q

# 10. INSTALL REDIS

# install dependencies
sudo apt-get install build-essential tcl

# change into writable directory, download sources, and unpack
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz

# build from sources
cd redis-stable
make
sudo make install

# configure Redis
sudo mkdir /etc/redis
sudo mkdir /var/redis
sudo cp utils/redis_init_script /etc/init.d/redis_6379

# check REDISPORT option
sudo vi /etc/init.d/redis_6379

sudo cp redis.conf /etc/redis/6379.conf
sudo mkdir /var/redis/6379

# daemonize - yes
# pidfile - /var/run/redis_6379.pid
# logfile - /var/log/redis_6379.log
# dir - /var/redis/6379
sudo vi /etc/redis/6379.conf

sudo update-rc.d redis_6379 defaults
sudo /etc/init.d/redis_6379 start

# 11. SET ENVIRONMENT VARIABLES

sudo vi /etc/envoronment
sudo vi /home/deployer/.app

# 12. CONFIGURE SIDEKIQ

# create configurations file (content in sidekiq.service)
sudo vi /lib/systemd/system/sidekiq.service

# reload systemd daemon and start the service
sudo systemctl daemon-reload
sudo systemctl start sidekiq
