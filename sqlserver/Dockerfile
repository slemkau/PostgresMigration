FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer
ENV SA_PASSWORD=YourStrong!Passw0rd

USER root

# Copy your init scripts
COPY ./sql/init-db.sql /usr/src/sql/init-db.sql
COPY ./sql/create-types.sql /usr/src/sql/create-types.sql
COPY ./sql/create-tables.sql /usr/src/sql/create-tables-1.sql
COPY ./sql/create-views.sql /usr/src/sql/create-views.sql
COPY ./sql/create-sprocs.sql /usr/src/sql/create-sprocs.sql
COPY ./sql/seed-data.sql /usr/src/sql/seed-data.sql
COPY ./entrypoint.sh /usr/src/sql/entrypoint.sh

RUN chmod +x /usr/src/sql/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/usr/src/sql/entrypoint.sh"]
