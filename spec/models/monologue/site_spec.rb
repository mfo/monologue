require 'spec_helper'

describe Monologue::Site, type: :model do
  before(:each) do
    @site = Factory(:site)
    puts @site.domain.inspect
  end

  it { validate_presence_of(:name) }

  it 'is valid with valid attributes' do
    @site.should be_valid
  end

  it { validate_presence_of(:domain) }
end
