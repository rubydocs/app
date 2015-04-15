every :day do
  runner 'Services::DocCollections::PerformChecks.call'
end

every :hour, at: '00:15' do
  runner 'Services::Projects::UpdateTagsForAll.call'
end

every 5.minutes do
  runner 'Services::DocCollections::ProcessSome.call', output: { standard: nil }
end
