# frozen_string_literal: true
require 'spec_helper'
describe 'tag category' do
  describe 'Viewing the tag category' do
    before(:each) do
      @site = Factory(:site)
      Factory(:post_with_tags, site: @site)
      post = Factory(:post,
                     title: 'Future post',
                     published_at: DateTime.new(3000),
                     site: @site)
      post.tag!(['Rails', 'another tag'])
    end

    it 'should only display the frequency of tags used by published post' do
      visit root_url(domain: @site.domain)
      page.should have_content('Rails (1)')
    end
  end
end
