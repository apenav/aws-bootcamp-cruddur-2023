<!-- TOC ignore:true -->

# Week 4 — Postgres and RDS
<!-- TOC -->

- [Week 4 — Postgres and RDS](#week-4--postgres-and-rds)
- [Required Homework/Tasks](#required-homeworktasks)
    - [Create RDS Postgres Instance](#create-rds-postgres-instance)
    - [Bash scripting for common database actions](#bash-scripting-for-common-database-actions)
    - [Install Postgres Driver in Backend Application](#install-postgres-driver-in-backend-application)
    - [Connect Gitpod to RDS Instance](#connect-gitpod-to-rds-instance)
    - [Create Cognito Trigger to insert user into database](#create-cognito-trigger-to-insert-user-into-database)
    - [Create new activities with a database insert](#create-new-activities-with-a-database-insert)
    - [Difficulties](#difficulties)
        - [Error with configuration of Cognito pool and workaround applied](#error-with-configuration-of-cognito-pool-and-workaround-applied)

<!-- /TOC -->

# Required Homework/Tasks

Files commited under their respective folders, having a working app as a result.

When production DB is not started:

```
PoolTimeout
psycopg_pool.PoolTimeout: couldn't get a connection after 30.0 sec

Traceback (most recent call last)
File "/usr/local/lib/python3.10/site-packages/flask/app.py", line 2551, in __call__
return self.wsgi_app(environ, start_response)
File "/usr/local/lib/python3.10/site-packages/opentelemetry/instrumentation/flask/__init__.py", line 345, in _wrapped_app
result = wsgi_app(wrapped_app_environ, _start_response)
File "/usr/local/lib/python3.10/site-packages/flask/app.py", line 2531, in wsgi_app
response = self.handle_exception(e)
File "/usr/local/lib/python3.10/site-packages/flask_cors/extension.py", line 165, in wrapped_function
return cors_after_request(app.make_response(f(*args, **kwargs)))
File "/usr/local/lib/python3.10/site-packages/flask/app.py", line 2528, in wsgi_app
response = self.full_dispatch_request()
File "/usr/local/lib/python3.10/site-packages/flask/app.py", line 1825, in full_dispatch_request
rv = self.handle_user_exception(e)
File "/usr/local/lib/python3.10/site-packages/flask_cors/extension.py", line 165, in wrapped_function
return cors_after_request(app.make_response(f(*args, **kwargs)))
File "/usr/local/lib/python3.10/site-packages/flask/app.py", line 1823, in full_dispatch_request
rv = self.dispatch_request()
File "/usr/local/lib/python3.10/site-packages/flask/app.py", line 1799, in dispatch_request
return self.ensure_sync(self.view_functions[rule.endpoint])(**view_args)
File "/usr/local/lib/python3.10/site-packages/aws_xray_sdk/core/models/subsegment.py", line 54, in __call__
return self.recorder.record_subsegment(
File "/usr/local/lib/python3.10/site-packages/aws_xray_sdk/core/recorder.py", line 462, in record_subsegment
six.raise_from(exc, exc)
File "<string>", line 3, in raise_from
File "/usr/local/lib/python3.10/site-packages/aws_xray_sdk/core/recorder.py", line 457, in record_subsegment
return_value = wrapped(*args, **kwargs)
File "/backend-flask/app.py", line 180, in data_home
data = HomeActivities.run()
File "/backend-flask/services/home_activities.py", line 16, in run
results = db.query_array_json(sql)
File "/backend-flask/lib/db.py", line 65, in query_array_json
with self.pool.connection() as conn:
File "/usr/local/lib/python3.10/contextlib.py", line 135, in __enter__
return next(self.gen)
File "/usr/local/lib/python3.10/site-packages/psycopg_pool/pool.py", line 138, in connection
conn = self.getconn(timeout=timeout)
File "/usr/local/lib/python3.10/site-packages/psycopg_pool/pool.py", line 182, in getconn
conn = pos.wait(timeout=timeout)
File "/usr/local/lib/python3.10/site-packages/psycopg_pool/pool.py", line 743, in wait
raise self.error
psycopg_pool.PoolTimeout: couldn't get a connection after 30.0 sec
The debugger caught an exception in your WSGI application. You can now look at the traceback which led to the error.
To switch between the interactive traceback and the plaintext one, you can click on the "Traceback" headline. From the text traceback you can also create a paste of it. For code execution mouse-over the frame you want to debug and click on the console icon on the right side.

You can execute arbitrary Python code in the stack frames and there are some extra helpers available for introspection:

dump() shows all variables in the frame
dump(obj) dumps all that's known about the object
Brought to you by DON'T PANIC, your friendly Werkzeug powered traceback interpreter.
```

Gitpod configuration

```
export PROD_CONNECTION_URL="postgresql://cruddurroot:@cruddur-db-instance.XXX.us-east-1.rds.amazonaws.com:5432/cruddur"
gp env PROD_CONNECTION_URL="postgresql://cruddurroot:@cruddur-db-instance.XXX.us-east-1.rds.amazonaws.com:5432/cruddur"

export CONNECTION_URL="postgresql://postgres:password@localhost:5432/cruddur"
gp env CONNECTION_URL="postgresql://postgres:password@localhost:5432/cruddur"

export DB_SG_ID="sg-XXX"
gp env DB_SG_ID="sg-XXX"
export DB_SG_RULE_ID="sgr-XXX"
gp env DB_SG_RULE_ID="sgr-XXX"

GITPOD_IP=$(curl ifconfig.me)

aws ec2 modify-security-group-rules \
    --group-id $DB_SG_ID \
    --security-group-rules "SecurityGroupRuleId=$DB_SG_RULE_ID,SecurityGroupRule={IpProtocol=tcp,FromPort=5432,ToPort=5432,CidrIpv4=$GITPOD_IP/32}"
```

## Create RDS Postgres Instance

rds-postgresql ![cruddr rds postgresql](assets/week4-rds-postgresql.PNG)

## Bash scripting for common database actions

## Install Postgres Driver in Backend Application

[requirements.txt](../backend-flask/requirements.txt)

```
psycopg[binary]
psycopg[pool]
```

## Connect Gitpod to RDS Instance

## Create Cognito Trigger to insert user into database

Layers Info

 ARN
 "psycopg2-py38 2 python3.8 - arn:aws:lambda:us-east-1:898466741470:layer:psycopg2-py38:2"

<https://github.com/jetbridge/psycopg2-lambda-layer>

After an office hour it has working.

## Create new activities with a database insert

Connecting the backend to the local docker postgresql database

```
      #CONNECTION_URL: "postgresql://postgres:password@db:5432/cruddur"
```

```
      CONNECTION_URL: "${PROD_CONNECTION_URL}"
```

After having connected the backend to the RDS database.
When  production DB is started the backend activities homepage shows
<https://4567-apenav-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io/api/activities/home> :

```
 [ {
    "created_at": "2023-03-23T19:07:21.652491",
    "display_name": "Andrew BC",
    "expires_at": "2023-04-02T19:07:21.652491",
    "handle": "abc",
    "likes_count": 0,
    "message": "This was imported as abc seed data!",
    "replies_count": 0,
    "reply_to_activity_uuid": null,
    "reposts_count": 0,
    "uuid": "33261cea-8479-433f-bc2f-df4669b92f85"
  },
  {
    "created_at": "2023-03-23T19:07:21.56802",
    "display_name": "Andrew Brown",
    "expires_at": "2023-04-02T19:07:21.56802",
    "handle": "andrewbrown",
    "likes_count": 0,
    "message": "This was imported as seed data!",
    "replies_count": 0,
    "reply_to_activity_uuid": null,
    "reposts_count": 0,
    "uuid": "280a13a7-0104-4d60-ab79-977abab49f02"
  }
]
```

cruddr **abc** user db data persist activities users![cruddr abc user db data persist activities users](assets/week4-cruddr-abc-user-db-data-persist-activities-users.PNG)
cruddr **abc** user db data![cruddr abc user db data](assets/week4-cruddr-abc-user-db-data.PNG)
cruddr **andrewbrown** user db data persist activities user![cruddr andrewbrown user db data persist activities user](assets/week4-cruddr-andrewbrown-user-db-data-persist-activities-users.PNG)
week4 cruddr **andrewbrown** user db data persist home backend![week4 cruddr andrewbrown user db data persist home backendn](assets/week4-cruddr-andrewbrown-user-db-data-persist-home-backend.PNG)
cruddr psql prod rds backend local log![cruddr psql prod rds backend local log](assets/week4-cruddr-andrewbrown-user-db-data-persist-home-frontend.PNG)
week4 cruddr psql prod rds backend local log![week4 cruddr psql prod rds backend local log](assets/week4-cruddr-psql-prod-rds-backend-local-log.PNG)
week4 cruddr psql prod rds db connections![week4 cruddr psql prod rds db connections](assets/week4-cruddr-psql-prod-rds-db-connections.PNG)
week4 cruddr psql prod rds local stopped![week4 cruddr psql prod rds local stopped](assets/week4-cruddr-psql-prod-rds-local-stopped.PNG)
cruddr psql prod rds seed![cruddr psql prod rds seedn](assets/week4-cruddr-psql-prod-rds-seed.PNG)
cruddr psql prod rds stopped backend local log![ cruddr psql prod rds stopped backend local log](assets/week4-cruddr-psql-prod-rds-stopped-backend-local-log.PNG)

## Difficulties

With Andrew´s help during an office hour it has be make it working.

### Error with configuration of Cognito pool and workaround applied

week4 cruddr lambda prod failed devtools![week4 cruddr lambda prod failed devtools](assets/week4-cruddr-lambda-prod-failed-devtools.PNG)
week4 cruddr lambda prod failed![week4 cruddr lambda prod failed](assets/week4-cruddr-lambda-prod-failed.PNG)

<https://3000-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io/signup>

Docker compose up log:

```
frontend-react-js                        | webpack compiled with 1 error and 3 warnings
backend-flask                            | 192.168.121.71 - - [24/Mar/2023 18:19:33] "OPTIONS /api/activities/home HTTP/1.1" 200 -
backend-flask                            | [2023-03-24 18:19:33,311] DEBUG in app: authenticated
backend-flask                            | [2023-03-24 18:19:33,311] DEBUG in app: {'sub': 'fb609170-5411-47cd-bc27-c949621f1830', 'iss': 'https://cognito-idp.us-east-1.amazonaws.com/us-east-1_XXXXXXXXXXXXXXXXX', 'client_id': '4dohua9ds2lm9sh83ardiq2bng', 'origin_jti': '3b59ab67-f790-4512-80e7-c9568de23a5b', 'event_id': '1d6ed9ea-ebf3-462d-ad66-e305fd1b1b00', 'token_use': 'access', 'scope': 'aws.cognito.signin.user.admin', 'auth_time': 1679680219, 'exp': 1679683819, 'iat': 1679680219, 'jti': '85e6d315-b71c-43d2-9b31-bb7670e41145', 'username': 'user@mail.com'}
backend-flask                            | [2023-03-24 18:19:33,311] DEBUG in app: user@mail.com
backend-flask                            | 192.168.121.71 - - [24/Mar/2023 18:19:33] "GET /api/activities/home HTTP/1.1" 200 -
backend-flask                            | [2023-03-24 18:19:33,608] DEBUG in app: authenticated
backend-flask                            | [2023-03-24 18:19:33,609] DEBUG in app: {'sub': 'fb609170-5411-47cd-bc27-c949621f1830', 'iss': 'https://cognito-idp.us-east-1.amazonaws.com/us-east-1_XXXXXXXXXXXXXXXXX', 'client_id': '4dohua9ds2lm9sh83ardiq2bng', 'origin_jti': '3b59ab67-f790-4512-80e7-c9568de23a5b', 'event_id': '1d6ed9ea-ebf3-462d-ad66-e305fd1b1b00', 'token_use': 'access', 'scope': 'aws.cognito.signin.user.admin', 'auth_time': 1679680219, 'exp': 1679683819, 'iat': 1679680219, 'jti': '85e6d315-b71c-43d2-9b31-bb7670e41145', 'username': 'user@mail.com'}
backend-flask                            | [2023-03-24 18:19:33,609] DEBUG in app: user@mail.com
backend-flask                            | 192.168.121.71 - - [24/Mar/2023 18:19:33] "GET /api/activities/home HTTP/1.1" 200 -
aws-bootcamp-cruddur-2023-xray-daemon-1  | 2023-03-24T18:19:34Z [Info] Successfully sent batch of 1 segments (0.100 seconds)
backend-flask                            | Host: 4567-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 Edg/111.0.1661.44
backend-flask                            | Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
backend-flask                            | Accept-Encoding: gzip, deflate, br
backend-flask                            | Accept-Language: en-US,en;q=0.9,es;q=0.8,ca;q=0.7,fr;q=0.6,it;q=0.5
backend-flask                            | Cache-Control: max-age=0
backend-flask                            | Cookie: gp-necessary=true;gitpod-user=true
backend-flask                            | Dnt: 1
backend-flask                            | Referer: https://4567-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io/api/activities/home
backend-flask                            | Sec-Ch-Ua: "Microsoft Edge";v="111", "Not(A:Brand";v="8", "Chromium";v="111"
backend-flask                            | Sec-Ch-Ua-Mobile: ?0
backend-flask                            | Sec-Ch-Ua-Platform: "Windows"
backend-flask                            | Sec-Fetch-Dest: document
backend-flask                            | Sec-Fetch-Mode: navigate
backend-flask                            | Sec-Fetch-Site: same-origin
backend-flask                            | Sec-Gpc: 1
backend-flask                            | Upgrade-Insecure-Requests: 1
backend-flask                            | X-Forwarded-For: 188.26.212.124
backend-flask                            | X-Forwarded-Host: 4567-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | X-Forwarded-Port: 443
backend-flask                            | X-Forwarded-Proto: https
backend-flask                            | 
backend-flask                            | 
backend-flask                            | 
backend-flask                            | 
backend-flask                            |  Load SQL Template: /backend-flask/db/sql/activities/home.sql 
backend-flask                            |  SQL STATEMENT-[array]------
backend-flask                            | SELECT
backend-flask                            |   activities.uuid,
backend-flask                            |   users.display_name,
backend-flask                            |   users.handle,
backend-flask                            |   activities.message,
backend-flask                            |   activities.replies_count,
backend-flask                            |   activities.reposts_count,
backend-flask                            |   activities.likes_count,
backend-flask                            |   activities.reply_to_activity_uuid,
backend-flask                            |   activities.expires_at,
backend-flask                            |   activities.created_at
backend-flask                            | FROM public.activities
backend-flask                            | LEFT JOIN public.users ON users.uuid = activities.user_uuid
backend-flask                            | ORDER BY activities.created_at DESC
backend-flask                            | Host: 4567-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 Edg/111.0.1661.44
backend-flask                            | Accept: */*
backend-flask                            | Accept-Encoding: gzip, deflate, br
backend-flask                            | Accept-Language: en-US,en;q=0.9,es;q=0.8,ca;q=0.7,fr;q=0.6,it;q=0.5
backend-flask                            | Authorization: Bearer eyJraWQiOiJhVGVCS25XdHNBUEREckFGTWpFaGNnVjR3Q1NjTktzNTFXQ3ZiQ1lzT1V3PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJmYjYwOTE3MC01NDExLTQ3Y2QtYmMyNy1jOTQ5NjIxZjE4MzAiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9ORnpxVDNqTVUiLCJjbGllbnRfaWQiOiI0ZG9odWE5ZHMybG05c2g4M2FyZGlxMmJuZyIsIm9yaWdpbl9qdGkiOiIzYjU5YWI2Ny1mNzkwLTQ1MTItODBlNy1jOTU2OGRlMjNhNWIiLCJldmVudF9pZCI6IjFkNmVkOWVhLWViZjMtNDYyZC1hZDY2LWUzMDVmZDFiMWIwMCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2Nzk2ODAyMTksImV4cCI6MTY3OTY4MzgxOSwiaWF0IjoxNjc5NjgwMjE5LCJqdGkiOiI4NWU2ZDMxNS1iNzFjLTQzZDItOWIzMS1iYjc2NzBlNDExNDUiLCJ1c2VybmFtZSI6ImNoaWNoYW1vcmFkYTEyMzRAZ21haWwuY29tIn0.A6fe4_PZqR57S6nwj7poDpXLtuoOzexVtdaj1kO_DG1nMTZ1gyNG_o4UnOTJhYaYWs9d5iN3YWdDsqTqgP_jYTRHTo1saAkpQhRfYW5dUmJDs_r7qmSFwjwigWmqpRAF6j6RXR50GTzrcgLfCi3s35-l8TPkaiLNMKWD2LEtz7NKF0eJjXnvVpaX0ZfJgTAXaDKh8H0HtGgtGGY0DMpmtTqEPA34zWInGjnG8-6y7_SJj5DxRIXznP3fTzgo10cO6QU8dHsCsFnjeD-w-mf2MoIWX792nuVvGdOs-gcaD6ptkOkQ9-N3dZGrYFGh-xfrECXmKMDtXLVv7zkkGIxVdw
backend-flask                            | Cookie: 
backend-flask                            | Dnt: 1
backend-flask                            | Origin: https://3000-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | Referer: https://3000-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io/
backend-flask                            | Sec-Ch-Ua: "Microsoft Edge";v="111", "Not(A:Brand";v="8", "Chromium";v="111"
backend-flask                            | Sec-Ch-Ua-Mobile: ?0
backend-flask                            | Sec-Ch-Ua-Platform: "Windows"
backend-flask                            | Sec-Fetch-Dest: empty
backend-flask                            | Sec-Fetch-Mode: cors
backend-flask                            | Sec-Fetch-Site: same-site
backend-flask                            | Sec-Gpc: 1
backend-flask                            | X-Forwarded-For: 188.26.212.124
backend-flask                            | X-Forwarded-Host: 4567-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | X-Forwarded-Port: 443
backend-flask                            | X-Forwarded-Proto: https
backend-flask                            | 
backend-flask                            | 
backend-flask                            | 
backend-flask                            | 
backend-flask                            |  Load SQL Template: /backend-flask/db/sql/activities/home.sql 
backend-flask                            |  SQL STATEMENT-[array]------
backend-flask                            | SELECT
backend-flask                            |   activities.uuid,
backend-flask                            |   users.display_name,
backend-flask                            |   users.handle,
backend-flask                            |   activities.message,
backend-flask                            |   activities.replies_count,
backend-flask                            |   activities.reposts_count,
backend-flask                            |   activities.likes_count,
backend-flask                            |   activities.reply_to_activity_uuid,
backend-flask                            |   activities.expires_at,
backend-flask                            |   activities.created_at
backend-flask                            | FROM public.activities
backend-flask                            | LEFT JOIN public.users ON users.uuid = activities.user_uuid
backend-flask                            | ORDER BY activities.created_at DESC
backend-flask                            | Host: 4567-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36 Edg/111.0.1661.44
backend-flask                            | Accept: */*
backend-flask                            | Accept-Encoding: gzip, deflate, br
backend-flask                            | Accept-Language: en-US,en;q=0.9,es;q=0.8,ca;q=0.7,fr;q=0.6,it;q=0.5
backend-flask                            | Authorization: Bearer eyJraWQiOiJhVGVCS25XdHNBUEREckFGTWpFaGNnVjR3Q1NjTktzNTFXQ3ZiQ1lzT1V3PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJmYjYwOTE3MC01NDExLTQ3Y2QtYmMyNy1jOTQ5NjIxZjE4MzAiLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9ORnpxVDNqTVUiLCJjbGllbnRfaWQiOiI0ZG9odWE5ZHMybG05c2g4M2FyZGlxMmJuZyIsIm9yaWdpbl9qdGkiOiIzYjU5YWI2Ny1mNzkwLTQ1MTItODBlNy1jOTU2OGRlMjNhNWIiLCJldmVudF9pZCI6IjFkNmVkOWVhLWViZjMtNDYyZC1hZDY2LWUzMDVmZDFiMWIwMCIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiYXdzLmNvZ25pdG8uc2lnbmluLnVzZXIuYWRtaW4iLCJhdXRoX3RpbWUiOjE2Nzk2ODAyMTksImV4cCI6MTY3OTY4MzgxOSwiaWF0IjoxNjc5NjgwMjE5LCJqdGkiOiI4NWU2ZDMxNS1iNzFjLTQzZDItOWIzMS1iYjc2NzBlNDExNDUiLCJ1c2VybmFtZSI6ImNoaWNoYW1vcmFkYTEyMzRAZ21haWwuY29tIn0.A6fe4_PZqR57S6nwj7poDpXLtuoOzexVtdaj1kO_DG1nMTZ1gyNG_o4UnOTJhYaYWs9d5iN3YWdDsqTqgP_jYTRHTo1saAkpQhRfYW5dUmJDs_r7qmSFwjwigWmqpRAF6j6RXR50GTzrcgLfCi3s35-l8TPkaiLNMKWD2LEtz7NKF0eJjXnvVpaX0ZfJgTAXaDKh8H0HtGgtGGY0DMpmtTqEPA34zWInGjnG8-6y7_SJj5DxRIXznP3fTzgo10cO6QU8dHsCsFnjeD-w-mf2MoIWX792nuVvGdOs-gcaD6ptkOkQ9-N3dZGrYFGh-xfrECXmKMDtXLVv7zkkGIxVdw
backend-flask                            | Cookie: 
backend-flask                            | Dnt: 1
backend-flask                            | Origin: https://3000-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | Referer: https://3000-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io/
backend-flask                            | Sec-Ch-Ua: "Microsoft Edge";v="111", "Not(A:Brand";v="8", "Chromium";v="111"
backend-flask                            | Sec-Ch-Ua-Mobile: ?0
backend-flask                            | Sec-Ch-Ua-Platform: "Windows"
backend-flask                            | Sec-Fetch-Dest: empty
backend-flask                            | Sec-Fetch-Mode: cors
backend-flask                            | Sec-Fetch-Site: same-site
backend-flask                            | Sec-Gpc: 1
backend-flask                            | X-Forwarded-For: 188.26.212.124
backend-flask                            | X-Forwarded-Host: 4567-user-awsbootcampcrudd-t752jnhf57y.ws-eu92.gitpod.io
backend-flask                            | X-Forwarded-Port: 443
backend-flask                            | X-Forwarded-Proto: https
backend-flask                            | 
backend-flask                            | 
backend-flask                            | 
backend-flask                            | 
backend-flask                            |  Load SQL Template: /backend-flask/db/sql/activities/home.sql 
backend-flask                            |  SQL STATEMENT-[array]------
backend-flask                            | SELECT
backend-flask                            |   activities.uuid,
backend-flask                            |   users.display_name,
backend-flask                            |   users.handle,
backend-flask                            |   activities.message,
backend-flask                            |   activities.replies_count,
backend-flask                            |   activities.reposts_count,
backend-flask                            |   activities.likes_count,
backend-flask                            |   activities.reply_to_activity_uuid,
backend-flask                            |   activities.expires_at,
backend-flask                            |   activities.created_at
backend-flask                            | FROM public.activities
backend-flask                            | LEFT JOIN public.users ON users.uuid = activities.user_uuid
backend-flask                            | ORDER BY activities.created_at DESC
backend-flask                            | [2023-03-24 18:19:34,394] DEBUG in app: authenticated
backend-flask                            | [2023-03-24 18:19:34,394] DEBUG in app: {'sub': 'fb609170-5411-47cd-bc27-c949621f1830', 'iss': 'https://cognito-idp.us-east-1.amazonaws.com/us-east-1_XXXXXXXXXXXXXXXXX', 'client_id': '4dohua9ds2lm9sh83ardiq2bng', 'origin_jti': '3b59ab67-f790-4512-80e7-c9568de23a5b', 'event_id': '1d6ed9ea-ebf3-462d-ad66-e305fd1b1b00', 'token_use': 'access', 'scope': 'aws.cognito.signin.user.admin', 'auth_time': 1679680219, 'exp': 1679683819, 'iat': 1679680219, 'jti': '85e6d315-b71c-43d2-9b31-bb7670e41145', 'username': 'user@mail.com'}
backend-flask                            | [2023-03-24 18:19:34,394] DEBUG in app: user@mail.com
backend-flask                            | 192.168.121.71 - - [24/Mar/2023 18:19:34] "GET /api/activities/home HTTP/1.1" 200 -
aws-bootcamp-cruddur-2023-xray-daemon-1  | 2023-03-24T18:19:35Z [Info] Successfully sent batch of 1 segments (0.101 seconds)

```

when sub=f702eba1-f9fa-4171-8e0b-9e627c06757f

As a **workaroud** the exception was captured with the [lambda code]( ../aws/lambdas/cruddur-post-confirmation-capture-exception.py)

```
--- a/aws/lambdas/cruddur-post-confirmation.py
+++ b/aws/lambdas/cruddur-post-confirmation.py
@@ -10,7 +10,11 @@ def lambda_handler(event, context):
     user_display_name  = user['name']
     user_email         = user['email']
     user_handle        = user['preferred_username']
-    user_cognito_id    = user['sub']
+    try:
+      user_cognito_id    = user['sub']
+    except Exception as e:
+      print(e)
+    user_cognito_id     = "doesnt-matter"
```

 cruddr lambda prod mocked up RDS ![week4 cruddr lambda prod mocked up RDS](assets/week4-cruddr-lambda-prod-mocked-up-RDS.PNG)
 cruddr lambda prod mocked up devtool ![week4 cruddr lambda prod mocked up devtool](assets/week4-cruddr-lambda-prod-mocked-up-devtools.PNG)

```
frontend-react-js                        | (node:44) [DEP_WEBPACK_DEV_SERVER_ON_AFTER_SETUP_MIDDLEWARE] DeprecationWarning: 'onAfterSetupMiddleware' option is deprecated. Please use the 'setupMiddlewares' option.
frontend-react-js                        | (Use `node --trace-deprecation ...` to show where the warning was created)
frontend-react-js                        | (node:44) [DEP_WEBPACK_DEV_SERVER_ON_BEFORE_SETUP_MIDDLEWARE] DeprecationWarning: 'onBeforeSetupMiddleware' option is deprecated. Please use the 'setupMiddlewares' option.
frontend-react-js                        | Starting the development server...
frontend-react-js                        | 
aws-bootcamp-cruddur-2023-xray-daemon-1  | 2023-03-25T13:53:06Z [Error] Get instance id metadata failed: RequestError: send request failed
aws-bootcamp-cruddur-2023-xray-daemon-1  | caused by: Get "http://169.254.169.254/latest/meta-data/instance-id": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
aws-bootcamp-cruddur-2023-xray-daemon-1  | 2023-03-25T13:53:06Z [Info] HTTP Proxy server using X-Ray Endpoint : https://xray.us-east-1.amazonaws.com
aws-bootcamp-cruddur-2023-xray-daemon-1  | 2023-03-25T13:53:06Z [Info] Starting proxy http server on 0.0.0.0:2000
frontend-react-js                        | Compiled with warnings.
frontend-react-js                        | 
frontend-react-js                        | Warning
frontend-react-js                        | (4:3) autoprefixer: start value has mixed support, consider using flex-start instead
frontend-react-js                        | 
frontend-react-js                        | Warning
frontend-react-js                        | (3:3) autoprefixer: start value has mixed support, consider using flex-start instead
frontend-react-js                        | 
frontend-react-js                        | Warning
frontend-react-js                        | (3:3) autoprefixer: start value has mixed support, consider using flex-start instead
frontend-react-js                        | 
frontend-react-js                        | [eslint] 
frontend-react-js                        | src/components/DesktopNavigationLink.js
frontend-react-js                        |   Line 18:5:  Expected a default case  default-case
frontend-react-js                        | 
frontend-react-js                        | src/components/DesktopSidebar.js
frontend-react-js                        |   Line 36:9:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        |   Line 37:9:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        |   Line 38:9:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        | 
frontend-react-js                        | src/components/ReplyForm.js
frontend-react-js                        |   Line 4:27:  'BombIcon' is defined but never used  no-unused-vars
frontend-react-js                        | 
frontend-react-js                        | src/components/TrendItem.js
frontend-react-js                        |   Line 13:5:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        | 
frontend-react-js                        | src/pages/ConfirmationPage.js
frontend-react-js                        |   Line 72:6:  React Hook React.useEffect has a missing dependency: 'params.email'. Either include it or remove the dependency array  react-hooks/exhaustive-deps
frontend-react-js                        | 
frontend-react-js                        | src/pages/HomeFeedPage.js
frontend-react-js                        |   Line 13:8:  'Cookies' is defined but never used  no-unused-vars
frontend-react-js                        | 
frontend-react-js                        | src/pages/MessageGroupPage.js
frontend-react-js                        |   Line 16:10:  'popped' is assigned a value but never used                                                                                    no-unused-vars
frontend-react-js                        |   Line 81:6:   React Hook React.useEffect has a missing dependency: 'loadMessageGroupData'. Either include it or remove the dependency array  react-hooks/exhaustive-deps
frontend-react-js                        | 
frontend-react-js                        | src/pages/MessageGroupsPage.js
frontend-react-js                        |   Line 12:10:  'popped' is assigned a value but never used  no-unused-vars
frontend-react-js                        | 
frontend-react-js                        | src/pages/RecoverPage.js
frontend-react-js                        |   Line 27:18:   Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        |   Line 129:17:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        |   Line 132:22:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        |   Line 135:22:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        | 
frontend-react-js                        | src/pages/SigninPage.js
frontend-react-js                        |   Line 25:22:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        | 
frontend-react-js                        | src/pages/UserFeedPage.js
frontend-react-js                        |   Line 57:6:  React Hook React.useEffect has a missing dependency: 'loadData'. Either include it or remove the dependency array  react-hooks/exhaustive-deps
frontend-react-js                        | 
frontend-react-js                        | Search for the keywords to learn more about each warning.
frontend-react-js                        | To ignore, add // eslint-disable-next-line to the line before.
frontend-react-js                        | 
frontend-react-js                        | WARNING in ./src/components/ActivityContent.css (./node_modules/css-loader/dist/cjs.js??ruleSet[1].rules[1].oneOf[5].use[1]!./node_modules/postcss-loader/dist/cjs.js??ruleSet[1].rules[1].oneOf[5].use[2]!./node_modules/source-map-loader/dist/cjs.js!./src/components/ActivityContent.css)
frontend-react-js                        | Module Warning (from ./node_modules/postcss-loader/dist/cjs.js):
frontend-react-js                        | Warning
frontend-react-js                        | 
frontend-react-js                        | (4:3) autoprefixer: start value has mixed support, consider using flex-start instead
frontend-react-js                        | 
frontend-react-js                        | WARNING in ./src/components/MessageGroupItem.css (./node_modules/css-loader/dist/cjs.js??ruleSet[1].rules[1].oneOf[5].use[1]!./node_modules/postcss-loader/dist/cjs.js??ruleSet[1].rules[1].oneOf[5].use[2]!./node_modules/source-map-loader/dist/cjs.js!./src/components/MessageGroupItem.css)
frontend-react-js                        | Module Warning (from ./node_modules/postcss-loader/dist/cjs.js):
frontend-react-js                        | Warning
frontend-react-js                        | 
frontend-react-js                        | (3:3) autoprefixer: start value has mixed support, consider using flex-start instead
frontend-react-js                        | 
frontend-react-js                        | WARNING in ./src/components/MessageItem.css (./node_modules/css-loader/dist/cjs.js??ruleSet[1].rules[1].oneOf[5].use[1]!./node_modules/postcss-loader/dist/cjs.js??ruleSet[1].rules[1].oneOf[5].use[2]!./node_modules/source-map-loader/dist/cjs.js!./src/components/MessageItem.css)
frontend-react-js                        | Module Warning (from ./node_modules/postcss-loader/dist/cjs.js):
frontend-react-js                        | Warning
frontend-react-js                        | 
frontend-react-js                        | (3:3) autoprefixer: start value has mixed support, consider using flex-start instead
frontend-react-js                        | 
frontend-react-js                        | WARNING in [eslint] 
frontend-react-js                        | src/components/DesktopNavigationLink.js
frontend-react-js                        |   Line 18:5:  Expected a default case  default-case
frontend-react-js                        | 
frontend-react-js                        | src/components/DesktopSidebar.js
frontend-react-js                        |   Line 36:9:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        |   Line 37:9:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        |   Line 38:9:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        | 
frontend-react-js                        | src/components/ReplyForm.js
frontend-react-js                        |   Line 4:27:  'BombIcon' is defined but never used  no-unused-vars
frontend-react-js                        | 
frontend-react-js                        | src/components/TrendItem.js
frontend-react-js                        |   Line 13:5:  The href attribute requires a valid value to be accessible. Provide a valid, navigable address as the href value. If you cannot provide a valid href, but still need the element to resemble a link, use a button and change it with appropriate styles. Learn more: https://github.com/jsx-eslint/eslint-plugin-jsx-a11y/blob/HEAD/docs/rules/anchor-is-valid.md  jsx-a11y/anchor-is-valid
frontend-react-js                        | 
frontend-react-js                        | src/pages/ConfirmationPage.js
frontend-react-js                        |   Line 72:6:  React Hook React.useEffect has a missing dependency: 'params.email'. Either include it or remove the dependency array  react-hooks/exhaustive-deps
frontend-react-js                        | 
frontend-react-js                        | src/pages/HomeFeedPage.js
frontend-react-js                        |   Line 13:8:  'Cookies' is defined but never used  no-unused-vars
frontend-react-js                        | 
frontend-react-js                        | src/pages/MessageGroupPage.js
frontend-react-js                        |   Line 16:10:  'popped' is assigned a value but never used                                                                                    no-unused-vars
frontend-react-js                        |   Line 81:6:   React Hook React.useEffect has a missing dependency: 'loadMessageGroupData'. Either include it or remove the dependency array  react-hooks/exhaustive-deps
frontend-react-js                        | 
frontend-react-js                        | src/pages/MessageGroupsPage.js
frontend-react-js                        |   Line 12:10:  'popped' is assigned a value but never used  no-unused-vars
frontend-react-js                        | 
frontend-react-js                        | src/pages/RecoverPage.js
frontend-react-js                        |   Line 27:18:   Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        |   Line 129:17:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        |   Line 132:22:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        |   Line 135:22:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        | 
frontend-react-js                        | src/pages/SigninPage.js
frontend-react-js                        |   Line 25:22:  Expected '===' and instead saw '=='  eqeqeq
frontend-react-js                        | 
frontend-react-js                        | src/pages/UserFeedPage.js
frontend-react-js                        |   Line 57:6:  React Hook React.useEffect has a missing dependency: 'loadData'. Either include it or remove the dependency array  react-hooks/exhaustive-deps
frontend-react-js                        | 
frontend-react-js                        | webpack compiled with 4 warnings
backend-flask                            | 192.168.80.135 - - [25/Mar/2023 13:53:18] "OPTIONS /api/activities/home HTTP/1.1" 200 -
backend-flask                            | [2023-03-25 13:53:18,845] DEBUG in app: Error decoding token headers.
backend-flask                            | [2023-03-25 13:53:18,845] DEBUG in app: unauthenticated
backend-flask                            | 192.168.80.135 - - [25/Mar/2023 13:53:19] "GET /api/activities/home HTTP/1.1" 200 -
aws-bootcamp-cruddur-2023-xray-daemon-1  | 2023-03-25T13:53:20Z [Info] Successfully sent batch of 1 segments (0.365 seconds)
```

<https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#logsV2:log-groups/log-group/$252Faws$252Flambda$252Fcruddur-post-confirmation/log-events/2023$252F03$252F25$252F$255B$2524LATEST$255D3c50dc2e8bdf4579914018849194f6f1>

Cloudwatch Logs of the second version of the lambda execution:

```
2023-03-25T13:53:37.927Z INIT_START Runtime Version: python:3.8.v16 Runtime Version ARN: arn:aws:lambda:us-east-1::runtime:04f6192b7b9a4ad9cb43dc886a5f54868659e182e648f96d6f631cc0cbff8a68

2023-03-25T13:53:38.098Z START RequestId: 8de49d87-5faf-43a9-80d8-5d28b9f12558 Version: $LATEST

2023-03-25T13:53:38.098Z userAttributes

2023-03-25T13:53:38.098Z {'name': 'aeb', 'preferred_username': 'aeb', 'email': 'user@email.com'}

2023-03-25T13:53:38.098Z An exception of type KeyError occurred. Arguments:

2023-03-25T13:53:38.098Z ('sub',)

2023-03-25T13:53:38.098Z entered-try

2023-03-25T13:53:38.098Z SQL Statement ----

2023-03-25T13:53:38.098Z INSERT INTO public.users (

2023-03-25T13:53:38.098Z display_name,

2023-03-25T13:53:38.098Z email,

2023-03-25T13:53:38.098Z handle,

2023-03-25T13:53:38.098Z cognito_user_id

2023-03-25T13:53:38.098Z )

2023-03-25T13:53:38.098Z VALUES(%s,%s,%s,%s)

2023-03-25T13:53:38.442Z Database connection closed.

2023-03-25T13:53:38.443Z END RequestId: 8de49d87-5faf-43a9-80d8-5d28b9f12558

2023-03-25T13:53:38.443Z REPORT RequestId: 8de49d87-5faf-43a9-80d8-5d28b9f12558 Duration: 345.57 ms Billed Duration: 346 ms Memory Size: 128 MB Max Memory Used: 49 MB Init Duration: 170.56 ms

```
