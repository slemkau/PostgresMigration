alter sequence public.api_service_catalog_service_catalog_key_seq OWNER TO neondb_owner;

alter sequence public.api_service_catalog_service_catalog_key_seq owned by public.api_service_catalog.service_catalog_key;

alter sequence public.api_service_contract_service_contract_key_seq OWNER TO neondb_owner;

alter sequence public.api_service_contract_service_contract_key_seq owned by public.api_service_contract.service_contract_key;

alter sequence public.application_log_log_item_key_seq OWNER TO neondb_owner;

alter sequence public.application_log_log_item_key_seq owned by public.application_log.log_item_key;

grant select, usage on sequence public.application_log_log_item_key_seq to slemkau;

alter sequence public.sendgrid_template_email_template_key_seq OWNER TO neondb_owner;

alter sequence public.sendgrid_template_email_template_key_seq owned by public.sendgrid_template.email_template_key;

alter sequence public.sendgrid_log_email_item_key_seq OWNER TO neondb_owner;

alter sequence public.sendgrid_log_email_item_key_seq owned by public.sendgrid_log.email_item_key;

grant select, usage on sequence public.sendgrid_log_email_item_key_seq to slemkau;

alter sequence public.html_body_log_html_item_key_seq OWNER TO neondb_owner;

alter sequence public.html_body_log_html_item_key_seq owned by public.html_body_log.html_item_key;

grant select, usage on sequence public.html_body_log_html_item_key_seq to slemkau;

alter sequence public.parmgrid_log_parm_item_key_seq OWNER TO neondb_owner;

alter sequence public.parmgrid_log_parm_item_key_seq owned by public.parmgrid_log.parm_item_key;

grant select, usage on sequence public.parmgrid_log_parm_item_key_seq to slemkau;

alter sequence public.post_address_log_post_item_key_seq OWNER TO neondb_owner;

alter sequence public.post_address_log_post_item_key_seq owned by public.post_address_log.post_item_key;

grant select, usage on sequence public.post_address_log_post_item_key_seq to slemkau;

alter sequence public.attachment_log_attach_item_key_seq OWNER TO neondb_owner;

alter sequence public.attachment_log_attach_item_key_seq owned by public.attachment_log.attach_item_key;

grant select, usage on sequence public.attachment_log_attach_item_key_seq to slemkau;

alter sequence public.sendgrid_messages_msg_key_seq OWNER TO neondb_owner;

alter sequence public.sendgrid_messages_msg_key_seq owned by public.sendgrid_messages.msg_key;

grant select, usage on sequence public.sendgrid_messages_msg_key_seq to slemkau;

alter sequence public.sendgrid_events_event_key_seq OWNER TO neondb_owner;

alter sequence public.sendgrid_events_event_key_seq owned by public.sendgrid_events.event_key;

grant select, usage on sequence public.sendgrid_events_event_key_seq to slemkau;

alter sequence public.sendgrid_event_details_event_detail_key_seq OWNER TO neondb_owner;

alter sequence public.sendgrid_event_details_event_detail_key_seq owned by public.sendgrid_event_details.event_detail_key;

grant select, usage on sequence public.sendgrid_event_details_event_detail_key_seq to slemkau;

alter sequence public.audit_request_audit_key_seq owner to neondb_owner;

alter sequence public.audit_request_audit_key_seq owned by public.audit_request.audit_key;

