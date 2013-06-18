root = "/var/www/letsfleelaunch/current"
working_directory root
pid "/var/www/letsfleelaunch/current/tmp/pids/letsfleelaunch.pid"
shared_path = "/var/www/letsfleelaunch/shared"
stderr_path "#{root}/log/unicorn.stderr.log"
stdout_path "#{root}/log/unicorn.stdout.log"

listen "var/www/letsfleelaunch/current/tmp/letsfleelaunch.sock"
worker_processes 4
timeout 30
