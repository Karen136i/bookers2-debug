class Book < ApplicationRecord
  # book model に user model を紐づける
  belongs_to :user
  # バリデーションの追加
  validates :title,presence:true
  validates :body,presence:true, length: {maximum:200}
end
