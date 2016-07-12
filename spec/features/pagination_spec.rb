# encoding: UTF-8
# frozen_string_literal: true
require 'spec_helper'

describe 'pagination' do
  before(:each) do
    @site1 = Factory(:site)
    22.times { |i| Factory(:post, title: "post #{i}", site: @site1) }
  end

  it 'should not show all posts' do
    visit "http://www.#{@site1.domain}/monologue"
    within('.content.twelve.columns') do
      page.should_not have_content(
        "post #{Monologue::Config.posts_per_page + 1}"
      )
    end
  end

  it 'can go to older posts' do
    visit "http://www.#{@site1.domain}/monologue"
    home_page = page.html
    click_on 'Older posts'
    page.html.should_not eq(home_page)
  end

  it 'can go to newer posts' do
    visit "#{root_url(domain: @site1.domain)}page/2"
    page_2 = page.html
    click_on 'Newer posts'
    page.html.should_not eq(page_2)
  end

  it "should not show 'newer posts' on first page" do
    visit "http://www.#{@site1.domain}/monologue"
    page.should_not have_content('Newer posts')
  end

  it "should not show 'older posts' on last page" do
    visit "http://www.#{@site1.domain}/monologue/page/3"
    page.should_not have_content('Older posts')
  end
end
