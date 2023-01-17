require 'spec_helper'
require 'rack/test'

RSpec.describe 'Update record', :type => :feature do
  include Rack::Test::Methods

  def app
    DynamicDns
  end

  pending 'test getting a zone'

  pending 'test caching features'
end