CREATE DATABASE insights;
\connect insights

\i '/sql/user.sql'
\i '/sql/tables.sql'
\i '/sql/sequences_nocreate.sql'
\i '/sql/views.sql'
\i '/sql/routines.sql'

COPY api_service_catalog FROM '/data/APIServiceCatalog.tsv' WITH (FORMAT csv, DELIMITER E'\t');
COPY api_service_contract FROM '/data/APIServiceContract.tsv' WITH (FORMAT csv, DELIMITER E'\t');
COPY sendgrid_template FROM '/data/SendGridTemplate.tsv' WITH (FORMAT csv, DELIMITER E'\t');