FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_PID=Developer
ENV SA_PASSWORD=MyStr0ng!Pass123

USER root

# Copy your init scripts
COPY ./sql/init-db.sql /usr/src/sql/init-db.sql
COPY ./sql/create-artifacts.sql /usr/src/sql/create-artifacts.sql
# COPY ./sql/seed-data.sql /usr/src/sql/seed-data.sql
COPY ./entrypoint.sh /usr/src/sql/entrypoint.sh

RUN chmod +x /usr/src/sql/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/usr/src/sql/entrypoint.sh"]
