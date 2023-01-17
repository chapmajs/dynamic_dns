require 'spec_helper'

RSpec.describe User, :type => :model do

  it { is_expected.to validate_presence_of :username }
  it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

  it { expect(FactoryBot.build(:user, :username => 'inspect me').inspect).to eq 'inspect me' }

end