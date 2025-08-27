FROM debian:bullseye-slim

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=insights
ENV PGDATA=/pgdata

RUN apt-get update && \
    apt-get install -y gnupg2 wget lsb-release && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get install -y postgresql-15 postgresql-contrib && \
    mkdir -p /pgdata /run/postgresql && \
    chown -R postgres:postgres /pgdata /run/postgresql

USER postgres

COPY ./database/master.sql /sql/master.sql
COPY ./database /sql
COPY ./database/data /data

RUN /usr/lib/postgresql/15/bin/initdb -D /pgdata && \
    /usr/lib/postgresql/15/bin/pg_ctl -D /pgdata -o "-c listen_addresses=''" -w start && \
    psql -f /sql/master.sql && \
    /usr/lib/postgresql/15/bin/pg_ctl -D /pgdata -m fast stop

CMD ["/usr/lib/postgresql/15/bin/postgres", "-D", "/pgdata"]