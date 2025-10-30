#!/bin/bash

# Start SQL Server in the background
/opt/mssql/bin/sqlservr &

# Wait for SQL Server to be ready
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'MyStr0ng!Pass123' -l 30 -C -Q "SELECT 1" &> /dev/null

# Execute your scripts
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "MyStr0ng!Pass123" -l 30 -C -i /usr/src/sql/init-db.sql
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "MyStr0ng!Pass123" -l 30 -C -i /usr/src/sql/create-artifacts.sql
# /opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P "MyStr0ng!Pass123" -l 30 -No -i /usr/src/sql/seed-data.sql

# Bring SQL Server to foreground
wait
