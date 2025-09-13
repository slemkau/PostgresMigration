\connect postgres
DROP DATABASE IF EXISTS insights;

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
COPY audit_request FROM '/data/AuditRequest.tsv' WITH (FORMAT csv, DELIMITER E'\t');

SELECT setval('public.api_service_catalog_service_catalog_key_seq', (SELECT MAX(service_catalog_key) FROM public.api_service_catalog));
SELECT setval('public.api_service_contract_service_contract_key_seq', (SELECT MAX(service_contract_key) FROM public.api_service_contract));
SELECT setval('public.sendgrid_template_email_template_key_seq', (SELECT MAX(email_template_key) FROM public.sendgrid_template));
SELECT setval('public.audit_request_audit_key_seq', (SELECT MAX(audit_key) FROM public.audit_request));
