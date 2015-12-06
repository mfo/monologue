class Monologue::Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :taggings, class_name: "Monologue::Tagging"
  has_and_belongs_to_many :posts, class_name: "Monologue::Post"

  field :name, type: String
  field :name_downcase, type: String

  validates :name, uniqueness: true,presence: true

  index({name_downcase: 1})

  before_save do
    self.name_downcase = name.to_s.downcase
  end

  def posts_with_tag
    self.posts.published
  end

  def frequency
    posts_with_tag.size
  end
end
