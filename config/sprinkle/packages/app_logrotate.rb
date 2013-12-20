package :app_logrotate do
  description 'App logrotate'
  local_file = File.expand_path('../../assets/app/logrotate', __FILE__)
  remote_file = '/etc/logrotate.d/rubydocs'
  transfer local_file, remote_file
  verify do
    has_file remote_file
  end
end
