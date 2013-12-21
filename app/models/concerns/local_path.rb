module LocalPath
  def local_path
    Rails.root.join('files', self.class.name.underscore.pluralize, self.slug)
  end
end
