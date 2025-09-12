#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to be ready
sleep 30

# Execute your scripts
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourStrong!Passw0rd" -i /usr/src/sql/init-db.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourStrong!Passw0rd" -i /usr/src/sql/create-types.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourStrong!Passw0rd" -i /usr/src/sql/create-tables.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourStrong!Passw0rd" -i /usr/src/sql/create-views.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourStrong!Passw0rd" -i /usr/src/sql/create-sprocs.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "YourStrong!Passw0rd" -i /usr/src/sql/seed-data.sql

# Bring SQL Server to foreground
wait
