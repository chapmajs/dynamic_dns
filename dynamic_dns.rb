require 'sinatra/base'
require 'sinatra/activerecord'
require 'json'
require 'require_all'

# Require base types, in correct order, to deal with require_all upgrade to 2.x
require_relative 'models/resource_record.rb'
require_relative 'models/address_record.rb'

require_all 'models'
require_all 'services/**/*.rb'
require_all 'lib/sinatra/**/*.rb'

class DynamicDns < Sinatra::Base
  helpers Sinatra::AuthenticationHelper

  post '/update' do
    user = authenticate!

    service = RecordUpdateService.new
    service.user = user
    service.json_input = request.body.read
    service.execute

    content_type :text
    halt(422, 'Unprocessable JSON entity') if service.errors.any?

    'Success'
  end

  get '/zone/:name' do
    zone = Zone.includes(:resource_records).where(:name => params[:name])
    content_type :text

    if zone.size != 1
      halt(404, 'Not found')
    else
      zone = zone.first
    end

    etag(zone.serial) unless zone.resource_records_changed?

    service = ZoneExportService.new
    service.zone = zone
    service.execute
  end

  run! if app_file == $0
end