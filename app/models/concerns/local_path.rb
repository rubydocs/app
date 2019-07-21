module LocalPath
  def local_path
    Rails.root.join('tmp', 'files', self.class.name.underscore.pluralize, self.slug)
  end
end
