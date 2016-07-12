# frozen_string_literal: true
require 'spec_helper'

describe 'posts' do
  before(:each) do
    @site1 = Factory(:site)
    Factory(:post, title: 'post X', site: @site1)
  end

  it 'lists posts' do
    Factory(:post, title: 'post Y', site: @site1)
    visit "http://www.#{@site1.domain}/monologue"

    page.should have_content('post X')
    page.should have_content('post Y')
  end

  it 'routes to a post' do
    visit "http://www.#{@site1.domain}/monologue"
    within '.content.twelve.columns' do
      click_on 'post X'
    end
    page.should have_content('this is some text with accents éàöûù')
  end

  it 'has a feed' do
    visit feed_url(domain: @site1.domain)
    page.should have_content('post X')
  end

  it 'should return 404 on non existent post' do
    visit "http://www.#{@site1.domain}/monologue/this/is/a/404/url"
    page.should have_content(
      'You may have mistyped the address or the page may have moved'
    )
  end

  it 'should not show post with published date in the future' do
    Factory(:post,
            published_at: DateTime.new(3000),
            title: 'I am Marty McFly',
            site: @site1)
    visit root_url(domain: @site1.domain)
    page.should_not have_content 'I am Marty McFly'
  end

  it 'should not show an unpublished post' do
    Factory(:post, published: false, title: 'I am Marty McFly', site: @site1)
    visit root_url(domain: @site1.domain)
    page.should_not have_content 'I am Marty McFly'
  end

  context 'with different sites' do
    before(:each) do
      @site2 = Factory(:site, domain: '127.0.0.2.xip.io', locale: :fr)
    end

    it 'lists posts of site based on request domain name' do
      Factory(:post, title: 'post site 2', site: @site2)

      visit "http://www.#{@site1.domain}/monologue"

      page.should have_content('post X')
      page.should_not have_content('post site 2')

      visit "http://www.#{@site2.domain}/monologue"

      page.should_not have_content('post X')
      page.should have_content('post site 2')
    end
  end
end
