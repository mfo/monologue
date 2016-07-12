# encoding: UTF-8
# frozen_string_literal: true
require 'spec_helper'

describe 'feed' do
  before(:each) do
    @site1 = Factory(:site)
    Factory(:post, url: 'url/to/post', site: @site1)
  end

  # test to prevent regression for issue #72
  it 'contains full' do
    visit feed_url(domain: @site1.domain)
    page.should have_content '/monologue/url/to/post'
  end

  context 'with tags param' do
    before do
      create(:post, title: 'Feed Post', site: @site1).tag!(['feed'])
      create(:post, title: 'Rss Post', site: @site1).tag!(['rss'])
    end

    context 'with tags' do
      it 'returns posts tagged with tags' do
        visit feed_url(tags: 'feed,rss', domain: @site1.domain)
        page.should have_content 'Feed Post'
        page.should have_content 'Rss Post'
      end
    end

    context 'with tag' do
      it 'returns posts tagged with tags' do
        visit feed_url(tags: 'feed', domain: @site1.domain)
        page.should have_content 'Feed Post'
        page.should_not have_content 'Rss Post'
      end
    end

    context 'without tags' do
      it 'returns all posts' do
        visit feed_url(tags: '', domain: @site1.domain)
        page.should have_content 'Feed Post'
        page.should have_content 'Rss Post'
      end
    end
  end
end
