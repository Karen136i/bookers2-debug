class Book < ApplicationRecord
  # book model に user model を紐づける
  belongs_to :user
  # コメント機能の追加
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # バリデーションの追加
  validates :title,presence:true
  validates :body,presence:true, length: {maximum:200}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
end
