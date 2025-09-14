create table if not exists public.api_service_catalog
(
    service_catalog_key  serial
        primary key,
    service_catalog_name varchar(150),
    service_description  varchar(1000),
    api_product_category varchar(250),
    create_date_time     timestamp,
    modify_date_time     timestamp
);

alter table public.api_service_catalog
    OWNER TO neondb_owner;

grant select on public.api_service_catalog to slemkau;

create table if not exists public.api_service_contract
(
    service_contract_key          serial
        primary key,
    service_catalog_key           integer
        references public.api_service_catalog,
    service_name                  varchar(150),
    service_description           varchar(2000),
    service_availability          varchar(100),
    service_reusability           varchar(50),
    service_version               varchar(10),
    service_identifier            varchar(50),
    service_discoverable_url      varchar(150),
    service_binding               varchar(200),
    service_instance_info         varchar(2000),
    service_primary_end_point     varchar(150),
    service_source_systems        varchar(250),
    service_technical_owner       varchar(500),
    service_technical_description varchar(2000),
    service_business_owner        varchar(500),
    service_operations_owner      varchar(500),
    service_scope                 varchar(100),
    service_security              varchar(100)
);

alter table public.api_service_contract
    OWNER TO neondb_owner;

grant select on public.api_service_contract to slemkau;

create table if not exists public.application_log
(
    log_item_key                serial
        constraint pk_application_log
            primary key,
    log_item_id                 varchar(50)                         not null,
    severity                    varchar(50)                         not null,
    log_event_timestamp         timestamp                           not null,
    log_event_name              varchar(500)                        not null,
    log_event_description       varchar(4000),
    application_name            varchar(500)                        not null,
    application_service_account varchar(100),
    application_user            varchar(100),
    application_machine_name    varchar(100),
    application_exception       varchar(4000),
    application_stack           varchar(4000),
    application_thread          varchar(255),
    integration_source          varchar(250),
    integration_target          varchar(250),
    integration_message         text,
    related_policy_number       varchar(25),
    related_account_number      varchar(25),
    related_claim_number        varchar(25),
    business_entity_name        varchar(60),
    business_entity_id          varchar(25),
    business_entity_data        text,
    recorded_timestamp          timestamp default CURRENT_TIMESTAMP not null,
    service_contract_key        integer
);

comment on column public.application_log.log_item_key is 'Reference Key to APIServiceContract Catalog where applicable from an API or Application flow';

alter table public.application_log
    OWNER TO neondb_owner;

grant select, usage on sequence public.application_log_log_item_key_seq to slemkau;

create index if not exists ix_application_log
    on public.application_log (recorded_timestamp desc);

grant insert, select on public.application_log to slemkau;

create table if not exists public.sendgrid_template
(
    email_template_key  serial
        primary key,
    email_template_guid varchar(50)               not null,
    email_template_name varchar(100)              not null,
    email_template_body text,
    email_template_date date default CURRENT_DATE not null
);

alter table public.sendgrid_template
    OWNER TO neondb_owner;

grant select on public.sendgrid_template to slemkau;

create table if not exists public.sendgrid_log
(
    email_item_key          serial
        primary key,
    email_item_id           uuid                                                                 not null,
    email_template_key      integer      default 1                                               not null
        constraint fk_sendgrid_log_template
            references public.sendgrid_template,
    email_template_guid     varchar(50),
    email_template_name     varchar(100)                                                         not null,
    email_request_timestamp timestamp                                                            not null,
    email_request_status    varchar(50)  default 'Initiated'::character varying                  not null,
    email_recipient_address varchar(256)                                                         not null,
    email_recipient_name    varchar(256),
    source_machine_name     varchar(100),
    machine_name            varchar(100),
    recorded_timestamp      timestamp    default CURRENT_TIMESTAMP                               not null,
    email_subject           varchar(100),
    x_message_id            varchar(50),
    email_from_address      varchar(256) default 'noreply@prosightdirect.com'::character varying not null,
    email_from_name         varchar(256)
);

alter table public.sendgrid_log
    OWNER TO neondb_owner;

grant select, usage on sequence public.sendgrid_log_email_item_key_seq to slemkau;

create index if not exists ix_sendgrid_log_recorded_timestamp
    on public.sendgrid_log (recorded_timestamp desc);

grant insert, select, update on public.sendgrid_log to slemkau;

create table if not exists public.html_body_log
(
    html_item_key  serial
        primary key,
    email_item_key integer not null
        constraint fk_html_body_log_sendgrid_log
            references public.sendgrid_log
            on delete cascade,
    html_body      text    not null
);

alter table public.html_body_log
    OWNER TO neondb_owner;

grant select, usage on sequence public.html_body_log_html_item_key_seq to slemkau;

grant insert, select on public.html_body_log to slemkau;

create table if not exists public.parmgrid_log
(
    parm_item_key  serial
        primary key,
    email_item_key integer     not null
        constraint fk_parmgrid_log_sendgrid_log
            references public.sendgrid_log
            on delete cascade,
    parm_name      varchar(50) not null,
    parm_value     varchar(1024)
);

alter table public.parmgrid_log
    OWNER TO neondb_owner;

grant select, usage on sequence public.parmgrid_log_parm_item_key_seq to slemkau;

grant insert, select on public.parmgrid_log to slemkau;

create table if not exists public.post_address_log
(
    post_item_key  serial
        primary key,
    email_item_key integer               not null
        constraint fk_post_address_log_sendgrid_log
            references public.sendgrid_log
            on delete cascade,
    display_name   varchar(100),
    address        varchar(256)          not null,
    cc             boolean default false not null
);

alter table public.post_address_log
    OWNER TO neondb_owner;

grant select, usage on sequence public.post_address_log_post_item_key_seq to slemkau;

grant insert, select on public.post_address_log to slemkau;

create table if not exists public.attachment_log
(
    attach_item_key serial
        primary key,
    email_item_key  integer           not null
        constraint fk_attachment_log_sendgrid_log
            references public.sendgrid_log
            on delete cascade,
    file_type       varchar(100),
    file_name       varchar(256)      not null,
    file_size       integer default 0 not null,
    content         bytea
);

alter table public.attachment_log
    OWNER TO neondb_owner;

grant select, usage on sequence public.attachment_log_attach_item_key_seq to slemkau;

grant insert, select, update on public.attachment_log to slemkau;

create table if not exists public.sendgrid_messages
(
    msg_key             serial
        primary key,
    from_email          varchar(256),
    msg_id              varchar(100)                                              not null,
    subject             varchar(100),
    to_email            varchar(256),
    status              varchar(50)                                               not null,
    opens_count         integer   default 0                                       not null,
    clicks_count        integer   default 0                                       not null,
    last_event_time     varchar(50)                                               not null,
    first_recorded_time timestamp default CURRENT_TIMESTAMP                       not null,
    last_accessed_time  timestamp default (CURRENT_TIMESTAMP - '1 day'::interval) not null,
    past_30_days        boolean   default false                                   not null
);

alter table public.sendgrid_messages
    OWNER TO neondb_owner;

grant select, usage on sequence public.sendgrid_messages_msg_key_seq to slemkau;

grant insert, select, update on public.sendgrid_messages to slemkau;

create table if not exists public.sendgrid_events
(
    event_key      serial
        primary key,
    msg_key        integer not null
        constraint fk_sendgrid_events_messages
            references public.sendgrid_messages
            on delete cascade,
    template_id    varchar(100),
    api_key_id     varchar(500),
    originating_ip varchar(25),
    categories     varchar(256)
);

alter table public.sendgrid_events
    OWNER TO neondb_owner;

grant select, usage on sequence public.sendgrid_events_event_key_seq to slemkau;

grant insert, select, update on public.sendgrid_events to slemkau;

create table if not exists public.sendgrid_event_details
(
    event_detail_key serial
        primary key,
    event_key        integer           not null
        constraint fk_event_details_events
            references public.sendgrid_events
            on delete cascade,
    event_name       varchar(50)       not null,
    processed        timestamp,
    reason           text,
    attempt_num      integer default 0 not null,
    mx_server        varchar(100),
    http_user_agent  text
);

alter table public.sendgrid_event_details
    OWNER TO neondb_owner;

grant select, usage on sequence public.sendgrid_event_details_event_detail_key_seq to slemkau;

grant insert, select, update on public.sendgrid_event_details to slemkau;

create table public.audit_request
(
    audit_key     serial
        constraint pk_audit_request
            primary key,
    id            varchar(50),
    id_type       varchar(50)
        constraint ck_id_type
            check ((id_type)::text = ANY
                   ((ARRAY ['OneCRM Case'::character varying, 'Pathway CSM'::character varying, 'Confirm Enquiry'::character varying, 'Other'::character varying])::text[])),
    ds_id         varchar(50),
    ds_id_type    varchar(50),
    status        varchar(50)
        constraint ck_status
            check ((status)::text = ANY
                   ((ARRAY ['Success'::character varying, 'Warn'::character varying, 'Fail'::character varying])::text[])),
    subject       varchar(50),
    source_system varchar(50),
    destination   varchar(50),
    batch_id      varchar(50),
    audit_message varchar(500),
    timestamp     timestamp
);

alter table public.audit_request
    owner to neondb_owner;

grant select on public.audit_request to slemkau;

