app_path = '/home/services/dynamic_dns'

worker_processes 2
working_directory "#{app_path}/current"

timeout 30

# Drop the UNIX socket within the nginx chroot
listen '/var/www/run/unicorn/dynamic_dns.sock', :backlog => 64

pid '/var/run/unicorn/dynamic_dns.pid'

stderr_path '/var/log/unicorn/dynamic_dns_error.log'
stdout_path '/var/log/unicorn/dynamic_dns.log'

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end