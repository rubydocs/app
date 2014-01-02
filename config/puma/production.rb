environment 'production'
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'
stdout_redirect 'log/puma.log', 'log/puma_err.log', true
threads 0, 4
workers 1
bind 'unix://tmp/pids/puma.sock'
