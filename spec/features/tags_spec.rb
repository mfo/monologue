# encoding: UTF-8
# frozen_string_literal: true
require 'spec_helper'

describe 'tags' do
  before(:each) do
    @site1 = Factory(:site)
  end

  describe 'Viewing the list of posts with tags' do
    before(:each) do
      Factory(:post_with_tags, title: 'post X', site: @site1)
    end

    it 'should display the tags for the posts as a link' do
      visit "http://www.#{@site1.domain}/monologue"
      page.should have_link('Rails')
      page.should have_link('a great tag')
      page.should have_link("\u0422\u0435\u0441\u0442")
    end
  end

  describe 'filtering by a given tag' do
    before(:each) do
      @post = Factory(:post_with_tags, title: 'post X', site: @site1)
      Factory(:post, title: 'post Z', site: @site1)
    end

    it 'should only display posts with the given tag' do
      visit "http://www.#{@site1.domain}/monologue"
      page.should have_content('post Z')
      within 'section.widget-tags-cloud' do
        click_on 'Rails'
      end
      find('.content.twelve.columns').should have_content('post X')
      find('.content.twelve.columns').should_not have_content('post Z')
    end

    it 'should not display posts with tags with future publication date' do
      post = Factory(:post,
                     title: 'we need to reach 88 miles per hour',
                     published_at: DateTime.new(3000),
                     site: @site1)
      post.tag!(['rails', 'another tag'])
      visit "http://www.#{@site1.domain}/monologue"
      within 'section.widget-tags-cloud' do
        click_on 'Rails'
      end
      page.should have_content('post X')
      page.should_not have_content('we need to reach 88 miles per hour')
    end

    it 'should work with non-latin tag' do
      pending 'temporarily disabled because of problem with ruby 1.9.3'
      post = Factory(:post,
                     title: 'non-latin tag post title',
                     published_at: DateTime.new(3000),
                     site: @site1)
      post.tag!(%W(rails \u0422\u0435\u0441\u0442))
      visit "http://www.#{@site1.domain}/monologue"
      click_on "\u0422\u0435\u0441\u0442"
      page.should have_content('post X')
      page.should_not have_content('we need to reach 88 miles per hour')
    end
  end
end
