create or replace view public.notification_vw
            (full_name, recorded, msg_id, company, parent, trade, status, certificate, issued, site_id) as
SELECT a.email_recipient_name                          AS full_name,
       a.recorded_timestamp                            AS recorded,
       b.msg_id,
       COALESCE(b.to_email, a.email_recipient_address) AS company,
       a.email_recipient_address                       AS parent,
       e.email_template_name                           AS trade,
       a.email_request_status                          AS status,
       d.event_name                                    AS certificate,
       d.processed                                     AS issued,
       a.email_item_key                                AS site_id
FROM sendgrid_log a
         LEFT JOIN sendgrid_messages b
                   ON SUBSTRING(b.msg_id FROM 1 FOR POSITION(('.recvd'::text) IN (b.msg_id)) - 1) = a.x_message_id::text
         LEFT JOIN sendgrid_events c ON b.msg_key = c.msg_key
         LEFT JOIN sendgrid_event_details d ON c.event_key = d.event_key
         JOIN sendgrid_template e ON a.email_template_guid::text = e.email_template_guid::text;

alter table public.notification_vw
    owner to postgres;

grant select on public.notification_vw to slemkau;

create or replace view public.notification_with_site_change
            (full_name, recorded, msg_id, company, parent, trade, status, certificate, issued, site_id, prev_site_id,
             show_trade_again)
as
SELECT full_name,
       recorded,
       msg_id,
       company,
       parent,
       trade,
       status,
       COALESCE(certificate, status)                                                     AS certificate,
       issued,
       site_id,
       lag(site_id) OVER (PARTITION BY trade ORDER BY company, full_name, trade, issued) AS prev_site_id,
       CASE
           WHEN lag(site_id) OVER (PARTITION BY trade ORDER BY company, full_name, trade, issued) IS NOT NULL AND
                lag(site_id) OVER (PARTITION BY trade ORDER BY company, full_name, trade, issued) <> site_id THEN 1
           ELSE 0
           END                                                                           AS show_trade_again
FROM notification_vw;

alter table public.notification_with_site_change
    owner to postgres;

grant select on public.notification_with_site_change to slemkau;

