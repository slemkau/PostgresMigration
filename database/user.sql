-- Create the user
DO $$
    BEGIN
        IF NOT EXISTS (
            SELECT FROM pg_roles WHERE rolname = 'slemkau'
        ) THEN
            CREATE ROLE slemkau LOGIN PASSWORD 'Uakmels!1!2';
        END IF;
    END $$;

-- Grant access to the insights database
GRANT CONNECT ON DATABASE insights TO slemkau;

-- Optional: grant usage on schema
GRANT USAGE ON SCHEMA public TO slemkau;