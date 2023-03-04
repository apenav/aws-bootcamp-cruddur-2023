
export OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"
export OTEL_EXPORTER_OTLP_HEADERS="x-honeycomb-team="
export OTEL_SERVICE_NAME="backend-flask"

gp env OTEL_EXPORTER_OTLP_ENDPOINT="https://api.honeycomb.io"
gp env OTEL_EXPORTER_OTLP_HEADERS="x-honeycomb-team="
gp env OTEL_SERVICE_NAME="backend-flask"

export HONEYCOMB_API_KEY=
export HONEYCOMB_SERVICE_NAME="backend-flask"

gp env HONEYCOMB_API_KEY=
gp env HONEYCOMB_SERVICE_NAME="backend-flask"


export ROLLBAR_ACCESS_TOKEN=''
gp env ROLLBAR_ACCESS_TOKEN=''

export FLASK_ADDRESS="https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

gp env AWS_ACCESS_KEY_ID=
gp env AWS_SECRET_ACCESS_KEY=


export AWS_DEFAULT_REGION=us-east-1
export AWS_REGION=us-east-1

gp env AWS_DEFAULT_REGION=us-east-1
gp env AWS_REGION=us-east-1
