every :hour do
  runner 'Services::Projects::UpdateTagsForAll.perform_async'
end
