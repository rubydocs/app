# Load services manually since they are not loaded automatically because they don't adhere to Rails' ridiculously stringent naming conventions.
services = Dir[Rails.root.join('app', 'services', '**', '*.rb')].partition do |service|
  File.basename(service) == 'base.rb'
end.flatten

services.each do |file|
  require file
end
