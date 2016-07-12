# frozen_string_literal: true
require 'spec_helper'
describe 'preview' do
  before(:each) do
    @site = Factory(:site, domain: '127.0.0.1.xip.io')
    url = 'post/1'
    @post_url = "#{root_url(domain: @site.domain)}#{url}"
    @post_title = 'post 1'
    @post = Factory(:post, title: @post_title, url: url, site: @site)
    ActionController::Base.perform_caching = true
  end

  it 'verify unpublished posts are not public' do
    visit root_url(domain: @site.domain)
    Factory(:unpublished_post, site: @site)
    page.should_not have_content('unpublished')
    visit root_url(domain: @site.domain) + '/monologue/unpublished'
    page.should have_content(
      'You may have mistyped the address or the page may have moved'
    )
  end

  it 'admin users should be able to see the preview' do
    log_in
    visit @post_url
    page.should_not have_content(
      'You may have mistyped the address or the page may have moved'
    )
  end

  context 'admin section' do
    it 'clicks preview link', js: true do
      log_in
      visit admin_path
      click_on @post_title

      page.has_selector?("[data-toggle='post-preview']", visible: false)

      click_on 'Preview'
      page.should have_selector("[data-toggle='post-preview']", visible: true)

      within_frame 'preview' do
        page.has_content?(@post_title)
      end
    end

    it 'closes Preview', js: true do
      log_in
      visit admin_path
      click_on @post_title

      click_on 'Preview'
      page.should have_selector("[data-toggle='post-preview']", visible: true)
      link = find("[data-toggle='post-preview'] a")
      link.click
      page.should have_selector("[data-toggle='post-preview']", visible: false)
    end

    it 'clicking preview should not save' do
      log_in
      visit admin_path
      click_on @post_title
      new_content = "I'm modifying you but you shouldn't be saved"
      fill_in 'Content', with:  new_content
      click_on 'Preview'
      visit admin_path
      click_on @post_title
      page.should_not have_content(new_content)
      page.should have_content(@post.content)
    end
  end
end
