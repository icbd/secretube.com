namespace :machines_healthy do
  desc 'check machines healthy'
  task check: [:environment] do
    MachinesHealthyService.check
  end
end
