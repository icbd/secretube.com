set :output, error: 'log/cron_error.log', standard: 'log/cron_std.log'

every 1.day, at: '03:00' do
  rake 'machines_healthy:check'
end
