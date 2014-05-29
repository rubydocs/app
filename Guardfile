guard 'rspec', cmd: 'spring rspec', failed_mode: :none, all_after_pass: true, all_on_start: true do
  watch(%r(^spec/.+_spec\.rb$))
  watch('spec/spec_helper.rb')                        { 'spec' }
  watch(%r(^spec/support/(.+)\.rb$))                  { 'spec' }

  # Rails
  watch(%r(^app/(.+)\.rb$))                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r(^app/models/concerns/(.+)\.rb$))           { 'spec/models' }
  watch(%r(^lib/(.+)\.rb$))                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r(^app/controllers/(.+)_(controller)\.rb$))  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/requests/#{m[1]}_spec.rb"] }
  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }

  # Factories
  watch(%r(^spec/factories/(.+)_factory\.rb$))        { |m| ["spec/models/#{m[1]}_spec.rb", 'spec/factories_spec.rb'] }

  # Capybara request specs
  watch(%r(^app/views/(.+)/.*\.(erb|haml)$))          { |m| "spec/requests/#{m[1]}_spec.rb" }
end
