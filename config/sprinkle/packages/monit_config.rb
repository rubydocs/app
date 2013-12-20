package :monit_config do
  description 'Monit config'
  config_files = Dir[File.expand_path("../../assets/monit_config/*", __FILE__)].each_with_object({}) do |file, hash|
    hash[file] = "/etc/monit.d/#{File.basename(file)}"
  end
  runner 'mkdir -p /etc/monit.d'
  config_files.each do |local_file, remote_file|
    transfer local_file, remote_file
  end
  runner 'sudo monit reload'
  verify do
    config_files.values.each do |remote_file|
      has_file remote_file
    end
  end
end
