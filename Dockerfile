FROM debian:bullseye-slim

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=insights
ENV PGDATA=/pgdata

RUN apt-get update && \
    apt-get install -y gnupg2 wget lsb-release && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y postgresql-17 postgresql-contrib-17 && \
    mkdir -p /pgdata /run/postgresql && \
    chown -R postgres:postgres /pgdata /run/postgresql

USER postgres

COPY ./database/master.sql /sql/master.sql
COPY ./database /sql
COPY ./database/data /data

RUN /usr/lib/postgresql/15/bin/initdb -D /pgdata && \
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /pgdata/postgresql.conf && \
    echo "host all all 0.0.0.0/0 md5" >> /pgdata/pg_hba.conf && \
    /usr/lib/postgresql/15/bin/pg_ctl -D /pgdata -o "-c listen_addresses='*'" -w start && \
    psql -f /sql/master.sql && \
    /usr/lib/postgresql/15/bin/pg_ctl -D /pgdata -m fast stop

EXPOSE 5432
CMD ["/usr/lib/postgresql/15/bin/postgres", "-D", "/pgdata"]