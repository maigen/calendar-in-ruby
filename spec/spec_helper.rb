require 'active_record'
require 'rspec'

require 'event'
require 'date'

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSspec.configure do |config|
  config.after(:each) do
    Event.all.each { |event| event.destroy }
    Date.all.each { |date| date.destroy }
  end
end
