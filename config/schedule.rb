every :hour, at: '00:15' do
  runner 'Services::Projects::UpdateTagsForAll.call'
end

every 5.minutes do
  runner 'Services::Projects::DocCollections::ProcessSome.call'
end
