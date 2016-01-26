require 'sinatra/activerecord/rake'
require './dynamic_dns'

namespace :user do
  desc 'Create a new user for USERNAME with PASSWORD'
  task :create do
    user = User.create(
      :username => ENV['USERNAME'],
      :password => ENV['PASSWORD']
    )

    if user.errors.any?
      user.errors.messages.each { |field, errors| puts "Error on #{field.upcase}: #{errors.join(', ')}" }
    end
  end
end
