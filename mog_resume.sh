#!/bin/bash

#email_name=""
#password_passwd=""


# 获取 accessToken
accessToken=`curl -s --request POST \
     --url https://api.mogenius.com/auth/login \
     --header 'Authorization: Basic OEVvREZMaHpxajRpZkc0N2tnV3l5cXI5QWRRN3ZIRFRqOkFldmdhS2VYYXJ1R245cjh6ZkgyUFh2ZkZpTHdpY0JnTQ==' \
     --header 'Content-Type: application/x-www-form-urlencoded' \
     --header 'X-Device: mogenius_api' \
     --header 'accept: application/json' \
     --data grant_type=password \
     --data email=$email_name \
     --data "password=$password_passwd" | python -m json.tool | grep "\"accessToken\": " | head -n 1 | awk -F '"' '{print $4}'`


#获取 namespace-id
namespace_id=`curl -s --request GET \
     --url https://api.mogenius.com/namespace/list \
     --header 'accept: application/json' \
     --header "authorization: Bearer $accessToken" | python -m json.tool | grep 'id' | awk -F '"' '{print $(NF-1)}'`

#获取service-name
service_name=`curl -s --request GET \
     --url https://api.mogenius.com/namespace/dashboard-stage-service-list \
     --header 'accept: application/json' \
     --header "authorization: Bearer $accessToken" \
     --header "namespace-id: $namespace_id" | python -m json.tool |  grep '^                "id": "' | tr -d ' ' | awk -F '"' '{print $(NF-1)}'`


#停止服务

curl -s --request GET \
     --url https://api.mogenius.com/namespace-service/stop-service/$service_name \
     --header 'accept: text/plain' \
     --header "authorization: Bearer $accessToken" \
     --header "namespace-id: $namespace_id"
curl -s --request GET \
     --url https://api.mogenius.com/namespace-service/start-service/$service_name \
     --header 'accept: text/plain' \
     --header "authorization: Bearer $accessToken" \
     --header "namespace-id: $namespace_id"
