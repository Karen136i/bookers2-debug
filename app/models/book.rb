class Book < ApplicationRecord
  # book model に user model を紐づける
  belongs_to :user
  # コメント機能の追加
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # バリデーションの追加
  validates :title,presence:true
  validates :body,presence:true, length: {maximum:200}

  # いいね機能の実装
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #検索機能の実装
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
