export APP_ROOT=$HOME
export LD_LIBRARY_PATH=$APP_ROOT/openresty/lib:$LD_LIBRARY_PATH:$APP_ROOT/openresty/lualib:$APP_ROOT/openresty/luajit

find $APP_ROOT

mkdir -p $APP_ROOT/openresty/nginx/logs

touch $APP_ROOT/openresty/nginx/logs/error.log
touch $APP_ROOT/openresty/nginx/logs/access.log

conf_file=$APP_ROOT/openresty/nginx/nginx/conf/nginx.conf

erb $conf_file > $APP_ROOT/openresty/nginx/nginx/conf/nginx-final.conf

# ------------------------------------------------------------------------------------------------

mkfifo $APP_ROOT/openresty/nginx/logs/access.log
mkfifo $APP_ROOT/openresty/nginx/logs/error.log

cat < $APP_ROOT/openresty/nginx/logs/access.log &
(>&2 cat) < $APP_ROOT/openresty/nginx/logs/error.log &

exec $APP_ROOT/openresty/nginx/nginx/sbin/nginx -p $APP_ROOT/openresty/nginx/nginx/ -c $APP_ROOT/openresty/nginx/nginx/conf/nginx-final.conf
# ------------------------------------------------------------------------------------------------
