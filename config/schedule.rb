every :hour, at: '00:15' do
  runner 'Services::Projects::UpdateTagsForAll.perform_async'
end
