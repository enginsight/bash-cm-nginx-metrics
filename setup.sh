    #
#   # #   Enginsight GmbH
# # # #   Geschäftsführer: Mario Jandeck, Eric Range
# #   #   Hans-Knöll-Straße 6, 07745 Jena
  #
  
# PLEASE READ ME!
# You need to enable "stub_status".
# See 
#   https://www.nginx.com/blog/monitoring-nginx/ or 
#   https://nginx.org/en/docs/http/ngx_http_stub_status_module.html
# for details:

server_status_url="http://127.0.0.1/nginx_status"

server_status=`curl -s $server_status_url | tr '\n' ' '`
active_connections="Active connections: ([0-9\.]+)"
writing="Writing: ([0-9\.]+)"
reading="Reading: ([0-9\.]+)"
waiting="Waiting: ([0-9\.]+)"

if [[ $server_status =~ $active_connections ]]; then
  nginx_active_connections=`awk "BEGIN {print (${BASH_REMATCH[1]})}"`
fi

if [[ $server_status =~ $writing ]]; then
  nginx_writing=`awk "BEGIN {print (${BASH_REMATCH[1]})}"`
fi

if [[ $server_status =~ $reading ]]; then
  nginx_reading=`awk "BEGIN {print (${BASH_REMATCH[1]})}"`
fi

if [[ $server_status =~ $waiting ]]; then
  nginx_waiting=`awk "BEGIN {print (${BASH_REMATCH[1]})}"`
fi

cat << EOF
__METRICS__={
  "nginx_active_connections": ${nginx_active_connections:-0},
  "nginx_writing": ${nginx_writing:-0},
  "nginx_reading": ${nginx_reading:-0},
  "nginx_waiting": ${nginx_waiting:-0}
}
EOF
