job_type :rollbar_runner, "cd :path && :environment_variable=:environment bundle exec rollbar-rails-runner :task --silent :output"

every :day do
  rollbar_runner 'DocCollections::PerformChecks.call'
end

every :hour, at: '00:15' do
  rollbar_runner 'Projects::UpdateTagsForAll.call'
end

every 5.minutes do
  rollbar_runner 'DocCollections::ProcessSome.call', output: nil
end
