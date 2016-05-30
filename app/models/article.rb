class Article < ActiveRecord::Base
  belongs_to :category
  has_many :edits, dependent: :destroy
  has_many :editors, through: :edits
  has_many :comments, dependent: :destroy
  has_many :commenters, through: :comments
  validates :title, :category_id, presence:true


  def toggle_featured
    update_attribute(:featured, !self.featured)
  end

  def toggle_published
    update_attribute(:published, !self.published)
  end

  def self.matched_articles(search_term)
    matches = []

    self.all.each do |article|
      if article.title.downcase.include?(search_term.downcase)
        matches << article
      elsif article.edits.last.content.downcase.include?(search_term.downcase)
        matches << article
      end
    end
    matches = matches.sort{|a,b| a.title <=> b.title}
  end
end
