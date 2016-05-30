class User < ActiveRecord::Base
  has_secure_password
  has_many :comments, foreign_key: :commenter_id
  has_many :commented_articles, through: :comments, source: :article
  has_many :edits, foreign_key: :editor_id
  has_many :edited_articles, through: :edits, source: :article

  validates :username, presence: true, uniqueness:true
  validates :email, presence: true

  def toggle_admin
    update_attribute(:admin, !self.admin)
  end

end
