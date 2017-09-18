# connect to PSQL
sudo -u postgres psql postgres

# connect to a specific database
\c database_name

# Execute SQL script
\i path_to_sql_file.sql

# list users
\du

# close PSQL
\q