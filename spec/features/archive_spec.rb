# frozen_string_literal: true
require 'spec_helper'

describe 'archive', type: :feature, js: true do
  before(:each) do
    @site1 = Factory(:site, domain: '127.0.0.1.xip.io')
    Factory(:post, title: 'post X', published_at: '2011-11-11', site: @site1)
  end

  it 'lists archived posts' do
    visit "http://www.#{@site1.domain}/monologue"
    within('.archive') do
      page.should have_content('2011')
      click_on '2011'
      page.should have_content('November')
      click_on 'November'
      page.should have_content('post X')
    end
  end
end
