# frozen_string_literal: true
#
# Monologue::Site class
#
class Monologue::Site
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :posts, class_name: 'Monologue::Post'

  field :domain, type: String
  field :layout, type: String
  field :locale, type: String
  field :meta_description, type: String
  field :meta_keyword, type: String
  field :name, type: String
  field :subtitle, type: String
  field :title, type: String

  validates :name, :locale, presence: true
  validates :domain, presence: true, uniqueness: true
  validate :domain_is_rfc1035_compliant

  index(domain: 1)

  def domain_is_rfc1035_compliant
    errors.add(
      :domain,
      I18n.t('mongoid.errors.models.monologue/site.attributes.domain.too_short')
    ) if domain.length < 3

    errors.add(
      :domain,
      I18n.t('mongoid.errors.models.monologue/site.attributes.domain.too_long')
    ) if 63 <= domain.length

    errors.add(
      :domain,
      I18n.t('mongoid.errors.models.monologue/site.attributes.domain.format')
    ) unless
      domain =~
      /\A[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*\z/i
  end
end
