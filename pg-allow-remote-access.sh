# update AWS inbound rules to allow connections on 5432 port

# set addresses PG server should listen to
#   listen_addresses = '1.2.3.4, 5.6.7.8' or '*'  
sudo vi /etc/postgresql/9.6/main/postgresql.conf

# open PG for external access
#   host all all 0.0.0.0/0 md5
sudo vi /etc/postgresql/9.6/main/pg_hba.conf

# restart PG
sudo /etc/init.d/postgresql restart
