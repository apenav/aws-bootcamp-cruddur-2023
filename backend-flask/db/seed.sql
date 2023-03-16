-- this file was manually created
INSERT INTO public.users (display_name, handle, email, cognito_user_id)
VALUES
  ('Andrew Brown', 'andrewbrown', 'email1@host','MOCK'),
  ('Andrew Bayko', 'bayko' , 'email2@host','MOCK'),
  ('Andrew BC', 'abc' , 'email3@host','MOCK');


INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'andrewbrown' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  );
INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'abc' LIMIT 1),
    'This was imported as abc seed data!',
    current_timestamp + interval '10 day'
  )
