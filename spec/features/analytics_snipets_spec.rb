# encoding: UTF-8
# frozen_string_literal: true
require 'spec_helper'
describe 'analytics code snipets' do
  before(:each) do
    @site = Factory(:site, domain: '127.0.0.1.xip.io')
  end

  describe 'gauge', js: true do
    it 'generate gauge snippet if site exists' do
      Monologue::Config.gauge_analytics_site_id = 'gauge id here'
      visit root_url(domain: @site.domain)
      page.should have_xpath('//script[' \
                             " @id='gauges-tracker' and " \
                             " @type='text/javascript' and " \
                             " @data-site-id='gauge id here'" \
                             ']',
                             visible: :hidden)
    end

    it 'does not generate gauge snippet if no site id has been set' do
      Monologue::Config.gauge_analytics_site_id = nil
      visit root_url(domain: @site.domain)
      page.should_not have_xpath('//script[' \
                                 " @id='gauges-tracker' and " \
                                 " @type='text/javascript' and " \
                                 " @data-site-id='gauge id here'" \
                                 ']',
                                 visible: :hidden)
    end
  end

  describe 'google analtycs', js: true do
    it 'generate GA snippet if site exists' do
      Monologue::Config.google_analytics_id = 'GA id'
      visit root_url(domain: @site.domain)
      page.should have_xpath(
        "//script[contains(., \"_gaq.push(['_setAccount', 'GA id'])\")]",
        visible: :hidden
      )
      page.should have_xpath('//script[' \
                             " @async='' and " \
                             " @type='text/javascript' and " \
                             " @src='http://www.google-analytics.com/ga.js'" \
                             ']',
                             visible: :hidden)
    end

    it 'does not generate GA snippet if no site id has been set' do
      Monologue::Config.google_analytics_id = nil
      visit root_url(domain: @site.domain)
      page.should_not have_xpath(
        "//script[contains(., \"_gaq.push(['_setAccount', 'GA id'])\")]",
        visible: :hidden
      )
      page.should_not have_xpath(
        '//script[' \
        " @async='' and " \
        " @type='text/javascript' and " \
        " @src='http://www.google-analytics.com/ga.js'" \
        ']',
        visible: :hidden
      )
    end
  end
end
