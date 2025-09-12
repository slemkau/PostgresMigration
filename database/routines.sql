create or replace function public.query_select_application_logs(from_date timestamp without time zone DEFAULT NULL::timestamp without time zone, to_date timestamp without time zone DEFAULT NULL::timestamp without time zone, severity_param character varying DEFAULT NULL::character varying, total_rows integer DEFAULT 1000)
    returns TABLE(row_number integer, log_item_key integer, log_item_id character varying, severity character varying, log_event_timestamp timestamp without time zone, log_event_name character varying, log_event_description character varying, application_name character varying, application_service_account character varying, application_user character varying, application_machine_name character varying, application_exception character varying, application_stack character varying, application_thread character varying, integration_source character varying, integration_target character varying, integration_message text, related_policy_number character varying, related_account_number character varying, related_claim_number character varying, business_entity_name character varying, business_entity_id character varying, business_entity_data text, recorded_timestamp timestamp without time zone, service_contract_key integer, service_name character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        WITH application_logs AS (
            SELECT
                        ROW_NUMBER() OVER (ORDER BY al.log_item_key DESC)::int AS row_number,
                        al.log_item_key,
                        al.log_item_id,
                        al.severity,
                        al.log_event_timestamp,
                        al.log_event_name,
                        al.log_event_description,
                        al.application_name,
                        al.application_service_account,
                        al.application_user,
                        al.application_machine_name,
                        al.application_exception,
                        al.application_stack,
                        al.application_thread,
                        al.integration_source,
                        al.integration_target,
                        al.integration_message,
                        al.related_policy_number,
                        al.related_account_number,
                        al.related_claim_number,
                        al.business_entity_name,
                        al.business_entity_id,
                        al.business_entity_data,
                        al.recorded_timestamp,
                        al.service_contract_key,
                        apisc.service_name
            FROM application_log al
                     LEFT JOIN api_service_contract apisc
                               ON al.service_contract_key = apisc.service_contract_key
            WHERE
                (from_date IS NULL OR al.recorded_timestamp > from_date) AND
                (to_date IS NULL OR al.recorded_timestamp < to_date) AND
                (severity_param IS NULL OR al.severity ILIKE severity_param)
        )
        SELECT als.row_number,
               als.log_item_key,
               als.log_item_id,
               als.severity,
               als.log_event_timestamp,
               als.log_event_name,
               als.log_event_description,
               als.application_name,
               als.application_service_account,
               als.application_user,
               als.application_machine_name,
               als.application_exception,
               als.application_stack,
               als.application_thread,
               als.integration_source,
               als.integration_target,
               als.integration_message,
               als.related_policy_number,
               als.related_account_number,
               als.related_claim_number,
               als.business_entity_name,
               als.business_entity_id,
               als.business_entity_data,
               als.recorded_timestamp,
               als.service_contract_key,
               als.service_name
        FROM application_logs als
        WHERE als.row_number <= total_rows;
END;
$$;

alter function public.query_select_application_logs(timestamp, timestamp, varchar, integer) owner to postgres;

create or replace function public.query_select_activity_logs(status_param character varying DEFAULT NULL::character varying, from_date timestamp without time zone DEFAULT NULL::timestamp without time zone, to_date timestamp without time zone DEFAULT NULL::timestamp without time zone, to_email_param character varying DEFAULT NULL::character varying, total_rows integer DEFAULT 1000)
    returns TABLE(row_number integer, msg_key integer, from_email character varying, msg_id character varying, subject character varying, last_event_time timestamp without time zone, to_email character varying, status character varying, opens_count integer, clicks_count integer, first_recorded_time timestamp without time zone, last_accessed_time timestamp without time zone, email_template_guid character varying)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        WITH send_message_logs AS (
            SELECT
                        ROW_NUMBER() OVER (ORDER BY sgm.first_recorded_time DESC)::INT AS row_number,
                        sgm.msg_key,
                        sgm.from_email,
                        sgm.msg_id,
                        sgm.subject,
                        sgm.last_event_time::TIMESTAMP,
                        sgm.to_email,
                        sgm.status,
                        sgm.opens_count,
                        sgm.clicks_count,
                        sgm.first_recorded_time::TIMESTAMP,
                        sgm.last_accessed_time::TIMESTAMP,
                        sgl.email_template_guid
            FROM public.sendgrid_messages sgm
                     LEFT JOIN public.sendgrid_log sgl
                               ON SUBSTRING(sgm.msg_id FROM 1 FOR LENGTH(sgl.x_message_id)) = sgl.x_message_id
            WHERE
                (from_date IS NULL OR sgm.first_recorded_time > from_date) AND
                (to_date IS NULL OR sgm.first_recorded_time < to_date) AND
                (to_email_param IS NULL OR sgm.to_email ILIKE to_email_param) AND
                (status_param IS NULL OR sgm.status ILIKE status_param)
        )
        SELECT
            sml.row_number,
            sml.msg_key,
            sml.from_email,
            sml.msg_id,
            sml.subject,
            sml.last_event_time,
            sml.to_email,
            sml.status,
            sml.opens_count,
            sml.clicks_count,
            sml.first_recorded_time,
            sml.last_accessed_time,
            sml.email_template_guid
        FROM send_message_logs sml
        WHERE total_rows = 0 OR sml.row_number <= total_rows;
END;
$$;

alter function public.query_select_activity_logs(varchar, timestamp, timestamp, varchar, integer) owner to postgres;

create or replace function public.query_select_sendgrid_logs(from_date timestamp without time zone DEFAULT NULL::timestamp without time zone, to_date timestamp without time zone DEFAULT NULL::timestamp without time zone, to_email character varying DEFAULT NULL::character varying, total_rows integer DEFAULT 1000)
    returns TABLE(row_number integer, email_item_key integer, email_item_id uuid, email_template_key integer, email_template_guid character varying, email_template_name character varying, email_request_timestamp timestamp without time zone, email_request_status character varying, email_recipient_address character varying, email_recipient_name character varying, source_machine_name character varying, machine_name character varying, recorded_timestamp timestamp without time zone, email_subject character varying, x_message_id character varying, email_from_address character varying, email_from_name character varying, html_body text)
    language plpgsql
as
$$
BEGIN
    RETURN QUERY
        WITH sendgrid_logs AS (
            SELECT
                        ROW_NUMBER() OVER (ORDER BY sgl.recorded_timestamp DESC)::int AS row_number,
                        sgl.email_item_key,
                        sgl.email_item_id,
                        sgl.email_template_key,
                        sgl.email_template_guid,
                        sgl.email_template_name,
                        sgl.email_request_timestamp::timestamp,
                        sgl.email_request_status,
                        sgl.email_recipient_address,
                        sgl.email_recipient_name,
                        sgl.source_machine_name,
                        sgl.machine_name,
                        sgl.recorded_timestamp::timestamp,
                        sgl.email_subject,
                        sgl.x_message_id,
                        sgl.email_from_address,
                        sgl.email_from_name,
                        hbl.html_body
            FROM sendgrid_log sgl
                     LEFT JOIN html_body_log hbl
                               ON sgl.email_item_key = hbl.email_item_key
            WHERE
                (from_date IS NULL OR sgl.recorded_timestamp > from_date) AND
                (to_date IS NULL OR sgl.recorded_timestamp < to_date) AND
                (to_email IS NULL OR sgl.email_recipient_address ILIKE to_email)
        )
        SELECT sgls.row_number,
               sgls.email_item_key,
               sgls.email_item_id,
               sgls.email_template_key,
               sgls.email_template_guid,
               sgls.email_template_name,
               sgls.email_request_timestamp,
               sgls.email_request_status,
               sgls.email_recipient_address,
               sgls.email_recipient_name,
               sgls.source_machine_name,
               sgls.machine_name,
               sgls.recorded_timestamp,
               sgls.email_subject,
               sgls.x_message_id,
               sgls.email_from_address,
               sgls.email_from_name,
               sgls.html_body
        FROM sendgrid_logs sgls
        WHERE sgls.row_number <= total_rows;
END;
$$;

alter function public.query_select_sendgrid_logs(timestamp, timestamp, varchar, integer) owner to postgres;

create or replace function public.ins_upd_activity_log(p_from_email character varying, p_msg_id character varying, p_subject character varying, p_to_email character varying, p_status character varying, p_opens_count integer, p_clicks_count integer, p_last_event_time character varying, p_first_recorded_time timestamp without time zone, p_sendgrid_events jsonb, p_sendgrid_details jsonb) returns void
    language plpgsql
as
$$
DECLARE
    v_msg_key int;
    v_event_key int;
    v_processed timestamp;
BEGIN
    -- Check if message exists
    SELECT msg_key INTO v_msg_key
    FROM sendgrid_messages
    WHERE msg_id = p_msg_id;

    IF FOUND THEN
        -- Update existing message
        UPDATE sendgrid_messages
        SET status = p_status,
            opens_count = p_opens_count,
            clicks_count = p_clicks_count,
            last_event_time = p_last_event_time,
            from_email = p_from_email,
            subject = p_subject
        WHERE msg_key = v_msg_key;

        -- Check for existing events
        SELECT event_key INTO v_event_key
        FROM sendgrid_events
        WHERE msg_key = v_msg_key;

        IF NOT FOUND THEN
            -- Insert new events from JSON array
            INSERT INTO sendgrid_events (msg_key, template_id, api_key_id, originating_ip, categories)
            SELECT v_msg_key,
                   event_data->>'template_id',
                   event_data->>'api_key_id',
                   event_data->>'originating_ip',
                   event_data->>'categories'
            FROM jsonb_array_elements(p_sendgrid_events) AS event_data
            WHERE event_data->>'template_id' IS NOT NULL
               OR event_data->>'api_key_id' IS NOT NULL
               OR event_data->>'originating_ip' IS NOT NULL
               OR event_data->>'categories' IS NOT NULL
            RETURNING event_key INTO v_event_key;

            -- Insert event details
            INSERT INTO sendgrid_event_details (event_key, event_name, processed, reason, attempt_num, mx_server, http_user_agent)
            SELECT v_event_key,
                   detail_data->>'event_name',
                   (detail_data->>'processed')::timestamp,
                   detail_data->>'reason',
                   (detail_data->>'attempt_num')::int,
                   detail_data->>'mx_server',
                   detail_data->>'http_user_agent'
            FROM jsonb_array_elements(p_sendgrid_details) AS detail_data
            WHERE detail_data->>'event_name' IS NOT NULL
               OR detail_data->>'processed' IS NOT NULL
               OR detail_data->>'reason' IS NOT NULL
               OR detail_data->>'attempt_num' IS NOT NULL
               OR detail_data->>'mx_server' IS NOT NULL
               OR detail_data->>'http_user_agent' IS NOT NULL;

            SELECT @processed = processed
            FROM sendgrid_event_details
            where event_name = 'processed' or event_name = 'drop';

            update sendgrid_messages set first_recorded_time = v_processed
            where v_msg_key = msg_key and v_processed is not null;

        ELSE
            -- Update existing events
            UPDATE sendgrid_events
            SET template_id = event_data->>'template_id',
                api_key_id = event_data->>'api_key_id',
                originating_ip = event_data->>'originating_ip',
                categories = event_data->>'categories'
            FROM jsonb_array_elements(p_sendgrid_events) AS event_data
            WHERE event_key = v_event_key;

            -- Insert new event details (avoiding duplicates)
            INSERT INTO sendgrid_event_details (event_key, event_name, processed, reason, attempt_num, mx_server, http_user_agent)
            SELECT v_event_key,
                   detail_data->>'event_name',
                   (detail_data->>'processed')::timestamp,
                   detail_data->>'reason',
                   (detail_data->>'attempt_num')::int,
                   detail_data->>'mx_server',
                   detail_data->>'http_user_agent'
            FROM jsonb_array_elements(p_sendgrid_details) AS detail_data
            WHERE length(detail_data->>'event_name') > 0
              AND ((detail_data->>'processed')::timestamp > (
                SELECT COALESCE(MAX(processed), '1900-01-01'::timestamp)
                FROM sendgrid_event_details
                WHERE event_key = v_event_key
            )
                OR (detail_data->>'event_name' IN ('processed', 'delivered', 'drop')
                    AND NOT EXISTS (
                        SELECT 1 FROM sendgrid_event_details
                        WHERE event_key = v_event_key
                          AND event_name = detail_data->>'event_name'
                    )
                       )
                );
        END IF;

    ELSE
        -- Insert new message
        INSERT INTO sendgrid_messages (
            from_email, msg_id, subject, to_email, status,
            opens_count, clicks_count, last_event_time, first_recorded_time
        )
        VALUES (
                   p_from_email, p_msg_id, p_subject, p_to_email, p_status,
                   p_opens_count, p_clicks_count, p_last_event_time, p_first_recorded_time
               )
        RETURNING msg_key INTO v_msg_key;

        -- Insert events for new message
        INSERT INTO sendgrid_events (msg_key, template_id, api_key_id, originating_ip, categories)
        SELECT v_msg_key,
               event_data->>'template_id',
               event_data->>'api_key_id',
               event_data->>'originating_ip',
               event_data->>'categories'
        FROM jsonb_array_elements(p_sendgrid_events) AS event_data
        WHERE event_data->>'template_id' IS NOT NULL
           OR event_data->>'api_key_id' IS NOT NULL
           OR event_data->>'originating_ip' IS NOT NULL
           OR event_data->>'categories' IS NOT NULL
        RETURNING event_key INTO v_event_key;

        -- Insert event details for new message
        INSERT INTO sendgrid_event_details (event_key, event_name, processed, reason, attempt_num, mx_server, http_user_agent)
        SELECT v_event_key,
               detail_data->>'event_name',
               (detail_data->>'processed')::timestamp,
               detail_data->>'reason',
               (detail_data->>'attempt_num')::int,
               detail_data->>'mx_server',
               detail_data->>'http_user_agent'
        FROM jsonb_array_elements(p_sendgrid_details) AS detail_data
        WHERE detail_data->>'event_name' IS NOT NULL
           OR detail_data->>'processed' IS NOT NULL
           OR detail_data->>'reason' IS NOT NULL
           OR detail_data->>'attempt_num' IS NOT NULL
           OR detail_data->>'mx_server' IS NOT NULL
           OR detail_data->>'http_user_agent' IS NOT NULL;

    END IF;
END;
$$;

alter function public.ins_upd_activity_log(varchar, varchar, varchar, varchar, varchar, integer, integer, varchar, timestamp, jsonb, jsonb) owner to postgres;

create or replace function public.ins_upd_sendgrid_log(p_email_item_id uuid, p_email_template_name character varying, p_email_request_timestamp timestamp without time zone, p_email_request_status character varying, p_email_recipient_address character varying, p_email_recipient_name character varying, p_email_from_address character varying, p_email_from_name character varying, p_html_body text, p_source_machine_name character varying, p_machine_name character varying, p_email_subject character varying, p_x_message_id character varying, p_parameter_array jsonb, p_post_address_array jsonb, p_attachment_array jsonb, p_email_template_guid character varying DEFAULT NULL::character varying) returns void
    language plpgsql
as
$$
DECLARE
    v_email_template_key int;
    v_email_template_key_count int;
    v_email_item_key int;
BEGIN
    -- Find or default email template key
    SELECT COUNT(email_template_key) INTO v_email_template_key_count
    FROM sendgrid_template
    WHERE REPLACE(email_template_name, ' ', '') = REPLACE(REPLACE(p_email_template_name, ' ', ''), '_', '');

    IF v_email_template_key_count = 0 THEN
        v_email_template_key := 1;
    ELSE
        SELECT email_template_key INTO v_email_template_key
        FROM sendgrid_template
        WHERE REPLACE(email_template_name, ' ', '') = REPLACE(REPLACE(p_email_template_name, ' ', ''), '_', '');
    END IF;

    -- Check if record exists
    IF EXISTS (SELECT 1 FROM sendgrid_log WHERE email_item_id = p_email_item_id) THEN
        -- Update existing record
        UPDATE sendgrid_log
        SET email_template_key = v_email_template_key,
            email_template_guid = p_email_template_guid,
            email_template_name = TRIM(p_email_template_name),
            email_request_timestamp = p_email_request_timestamp,
            email_request_status = p_email_request_status,
            email_recipient_address = p_email_recipient_address,
            email_recipient_name = p_email_recipient_name,
            email_from_address = p_email_from_address,
            email_from_name = p_email_from_name,
            source_machine_name = p_source_machine_name,
            machine_name = p_machine_name,
            email_subject = p_email_subject,
            x_message_id = p_x_message_id,
            recorded_timestamp = NOW()
        WHERE email_item_id = p_email_item_id;

    ELSE
        -- Insert new record
        INSERT INTO sendgrid_log (
            email_item_id, email_template_key, email_template_guid, email_template_name,
            email_request_timestamp, email_request_status, email_recipient_address,
            email_recipient_name, email_from_address, email_from_name, source_machine_name,
            machine_name, email_subject, x_message_id
        )
        VALUES (
                   p_email_item_id, v_email_template_key, p_email_template_guid, TRIM(p_email_template_name),
                   p_email_request_timestamp, p_email_request_status, p_email_recipient_address,
                   p_email_recipient_name, p_email_from_address, p_email_from_name, p_source_machine_name,
                   p_machine_name, p_email_subject, p_x_message_id
               )
        RETURNING email_item_key INTO v_email_item_key;

        -- Insert parameters from JSON array
        INSERT INTO parmgrid_log (email_item_key, parm_name, parm_value)
        SELECT v_email_item_key,
               param_data->>'parm_name',
               param_data->>'parm_value'
        FROM jsonb_array_elements(p_parameter_array) AS param_data
        WHERE LENGTH(param_data->>'parm_name') > 0;

        -- Insert post addresses from JSON array
        INSERT INTO post_address_log (email_item_key, display_name, address, cc)
        SELECT v_email_item_key,
               addr_data->>'display_name',
               addr_data->>'address',
               (addr_data->>'cc')::boolean
        FROM jsonb_array_elements(p_post_address_array) AS addr_data
        WHERE LENGTH(addr_data->>'address') > 0;

        -- Insert attachments from JSON array
        INSERT INTO attachment_log (email_item_key, file_type, file_name, file_size)
        SELECT v_email_item_key,
               attach_data->>'file_type',
               attach_data->>'file_name',
               (attach_data->>'file_size')::bigint
        FROM jsonb_array_elements(p_attachment_array) AS attach_data
        WHERE LENGTH(attach_data->>'file_name') > 0;

        -- Insert HTML body if not empty
        IF LENGTH(p_html_body) > 0 THEN
            INSERT INTO html_body_log (email_item_key, html_body)
            VALUES (v_email_item_key, p_html_body);
        END IF;

    END IF;
END;
$$;

alter function public.ins_upd_sendgrid_log(uuid, varchar, timestamp, varchar, varchar, varchar, varchar, varchar, text, varchar, varchar, varchar, varchar, jsonb, jsonb, jsonb, varchar) owner to postgres;

create or replace procedure public.upd_attachment_log(IN p_email_item_id uuid, IN p_file_name character varying, IN p_content bytea)
    language plpgsql
as
$$
BEGIN
    UPDATE attachment_log a
    SET content = p_content
    FROM sendgrid_log s
    WHERE s.email_item_key = a.email_item_key
      AND s.email_item_id = p_email_item_id
      AND a.file_name = p_file_name;
END;
$$;

alter procedure public.upd_attachment_log(uuid, varchar, bytea) owner to postgres;

create function public.query_select_audit_logs(p_status character varying DEFAULT NULL::character varying, p_from_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_to_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_subject character varying DEFAULT NULL::character varying, p_id character varying DEFAULT NULL::character varying, p_total_rows integer DEFAULT 1000)
    returns TABLE(row_number integer, audit_key integer, log_timestamp timestamp without time zone, id character varying, id_type character varying, ds_id character varying, ds_id_type character varying, status character varying, subject character varying, source_system character varying, destination character varying, batch_id character varying, audit_message character varying)
    language plpgsql
as
$$

begin
    return query
        with audit_logs as (
            select
                        row_number() over (order by a.audit_key desc)::int as row_number,
                        a.audit_key,
                        a.timestamp as log_timestamp,
                        a.id,
                        a.id_type,
                        a.ds_id,
                        a.ds_id_type,
                        a.status,
                        a.subject,
                        a.source_system,
                        a.destination,
                        a.batch_id,
                        a.audit_message
            from audit_request a
            where (a.timestamp > p_from_date or p_from_date is null)
              and (a.timestamp < p_to_date or p_to_date is null)
              and (p_status is null or a.status ilike p_status)
              and (p_subject is null or a.subject ilike p_subject)
              and (p_id is null or a.id ilike p_id)
        )
        select aus.row_number,
               aus.audit_key,
               aus.log_timestamp,
               aus.id,
               aus.id_type,
               aus.ds_id,
               aus.ds_id_type,
               aus.status,
               aus.subject,
               aus.source_system,
               aus.destination,
               aus.batch_id,
               aus.audit_message
        from audit_logs aus
        where aus.row_number <= p_total_rows;
end;
$$;

alter function public.query_select_audit_logs(varchar, timestamp, timestamp, varchar, varchar, integer) owner to postgres;

