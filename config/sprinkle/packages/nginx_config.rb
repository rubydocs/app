package :nginx_config do
  description 'Nginx config'
  local_file = File.expand_path('../../assets/nginx_config/rubydocs.conf', __FILE__)
  remote_file = '/etc/nginx/conf.d/rubydocs.conf'
  transfer local_file, remote_file
  verify do
    has_file remote_file
  end
end
