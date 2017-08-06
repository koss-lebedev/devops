# After certificate has been generated, download a version for `Apache` server.
# The archive will include certiicate for your domain as well as bundle of 
# intermediate certiicates. Merge them:
cat secure.mysite.com.crt gd_bundle.crt > combined.crt

# Upload certificate to Heroku:
heroku certs:add combined.crt server.key

# or upload them to AWS
scp /path/to/file username@a:/path/to/destination
scp -i mykey.pem somefile.txt root@my.ec2.id.amazonaws.com:~
