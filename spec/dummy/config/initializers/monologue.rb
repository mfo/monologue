Monologue.config do |c|
  # c.site_name = "@jipiboily / Jean-Philippe Boily"
  # c.site_subtitle = "my own place online"
  # c.site_url = "http://jipiboily.com"

  # c.meta_description = "This is my personal blog about Rails, Monologue, programming, etc..."
  # c.meta_keyword = "rails, programming, monologue, ruby"

  c.force_ssl = false
  c.admin_force_ssl = false
  c.posts_per_page = 10

  c.disqus_shortname = "jipiboily"

  # LOCALE
  c.twitter_locale = "en" # "fr"
  c.facebook_like_locale = "en_US" # "fr_CA"
  c.google_plusone_locale = "en"

  # c.layout               = "layouts/application"

  # ANALYTICS
  # c.gauge_analytics_site_id = "YOUR COGE FROM GAUG.ES"
  # c.google_analytics_id = "YOUR GA CODE"

  c.sidebar = %w(latest_posts
                 latest_tweets
                 categories
                 tag_cloud
                 archive
                 bestoff)

  #SOCIAL
  c.twitter_username = "jipiboily"
  c.facebook_url = "https://www.facebook.com/jipiboily"
  c.facebook_logo = 'logo.png'
  c.facebook_app_id="123465"
  c.use_pinterest= true
  c.google_plus_account_url = "https://plus.google.com/u/1/115273180419164295760/posts"
  c.linkedin_url = "http://www.linkedin.com/in/jipiboily"
  c.github_username = "jipiboily"
  c.show_rss_icon = true

  c.s3_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  c.s3_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  c.s3_bucket = ENV['S3_BUCKET']
  c.s3_end_point = ENV['S3_ENDPOINT']
  c.s3_host_alias = ENV['S3_HOST_ALIAS']
  c.s3_region = ENV['S3_AWS_REGION']
end
