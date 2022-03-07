class Category < ApplicationRecord
  has_many :book_tags, dependent: :destroy, foreign_key: 'category_id'
  has_many :books, through: :book_categories
  
  scope :merge_books, -> (categories){ }
  
  def self.search_books_for(content, method)
    
    if method == 'perfect'
      categories = Tag.where(name: content)
    elsif method == 'forward'
      categories = Tag.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      categories = Tag.where('name LIKE ?', '%' + content)
    else
      categories = Tag.where('name LIKE ?', '%' + content + '%')
    end
    
    return categories.inject(init = []) {|result, category| result + category.books}
    
  end
end
