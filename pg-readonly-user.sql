-- Create a group
CREATE ROLE readaccess;

-- Grant access to existing tables
GRANT USAGE ON SCHEMA public TO readaccess;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readaccess;

-- Grant access to future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readaccess;

-- Create a final user with password
CREATE USER username WITH PASSWORD 'secret';
GRANT readaccess TO username;

-- Allow user to log in
ALTER ROLE username WITH LOGIN;