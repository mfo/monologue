# frozen_string_literal: true
class Monologue::ApplicationController < ApplicationController
  include Monologue::ControllerHelpers::User

  force_ssl if Monologue::Config.force_ssl

  # TODO: find a way to test that.
  # It was asked in issue #54 (https://github.com/jipiboily/monologue/issues/54)
  layout Monologue::Config.layout if Monologue::Config.layout

  # only for front controllers
  before_action :load_site, :force_locale,
                :recent_posts, :all_tags,
                :archive_posts, if: proc { |controller|
                  !controller.class.to_s.start_with?('Monologue::Admin::')
                }

  def force_locale
    I18n.locale = @site.locale
  end

  def load_site
    @site = Monologue::Site.find_by(domain: request.domain)
  end

  def posts_for_site
    Monologue::Post.for_domain(request.domain)
  end

  def tags_for_site
    Monologue::Tag.for_domain(request.domain)
  end

  def recent_posts
    @recent_posts = posts_for_site.published.limit(3)
  end

  def all_tags
    @tags = tags_for_site.order([:name, :asc]).select { |t| t.frequency > 0 }
    # could use minmax here but it's only supported with ruby > 1.9'
    @tags_frequency_min = @tags.map(&:frequency).min
    @tags_frequency_max = @tags.map(&:frequency).max
  end

  def not_found
    # fallback to the default 404.html page from main_app.
    file = Rails.root.join('public', '404.html')
    if file.exist?
      render file: file.cleanpath.to_s.gsub(/#{file.extname}$/, ''),
             layout: false, status: 404, formats: [:html]
    else
      render action: '404', status: 404, formats: [:html]
    end
  end

  def archive_posts
    @archive_posts = {}
    @first_post_year = DateTime.now.year

    # limit to 100 for safety reasons
    posts = posts_for_site.published.limit(100)
    unless posts.empty?
      @archive_posts = posts.group_by do |post|
        post.published_at.beginning_of_month.strftime('%Y %-m')
      end
      @first_post_year = posts.last.published_at.year
    end
  end
end
