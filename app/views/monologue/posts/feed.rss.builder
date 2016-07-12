xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title @site.title
    xml.description @site.meta_description
    xml.link (Monologue::Config.force_ssl ? 'https' : 'http') + "://www.#{@site.domain}"

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description raw(post.content)
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link (Monologue::Config.force_ssl ? 'https' : 'http') + "://www.#{@site.domain}" + post.full_url
        xml.guid (Monologue::Config.force_ssl ? 'https' : 'http') + "://www.#{@site.domain}" + post.full_url
      end
    end
  end
end
