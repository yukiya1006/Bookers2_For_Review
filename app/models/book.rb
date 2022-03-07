class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # def save_categories(savebook_categories)
  #   # 現在のユーザーの持っているskillを引っ張ってきている
  #   current_categories = self.categories.pluck(:name) unless self.categories.nil?
  #   # 今bookが持っているタグと今回保存されたものの差をすでにあるタグとする。古いタグは消す。
  #   old_categories = current_categories - savebook_categories
  #   # 今回保存されたものと現在の差を新しいタグとする。新しいタグは保存
  #   new_categories = savebook_categories - current_categories

  #   # Destroy old taggings:
  #   old_categories.each do |old_name|
  #     self.categories.delete Category.find_by(name:old_name)
  #   end

  #   # Create new taggings:
  #   new_categories.each do |new_name|
  #     book_category = Category.find_or_create_by(name:new_name)
  #     # 配列に保存
  #     self.categories << book_category
  #   end
  # end

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end
