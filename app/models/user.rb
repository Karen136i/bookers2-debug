class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # User モデルに対して、book モデルが 1:N になるよう関連付ける 2-9:1:N の関係性をモデルに実装する
  has_many :books, dependent: :destroy
  
  # コメント機能の追加
  has_many :comments
  has_many :book_comments, dependent: :destroy
  
  # いいね機能の追加
  has_many :favorites, dependent: :destroy
  
  # フォロー・フォロワー機能の追加
  
  # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  # フォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed
  
  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower
  
  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end
  

  # 2-8 モデルに image を持たせる
  has_one_attached :profile_image

  # バリデーションの設定
  validates :name, length: { minimum: 2, message: "Name is too short (minimum is 2 characters)" }, uniqueness: true #2文字はダメ
  validates :name, length: { maximum: 20, message: "Name is too long (maximum is 20 characters)" } #20文字以上はダメ
  validates :introduction, length: { maximum: 50, message: "Introduction is too long (maximum is 50 characters)" } #50文字以上はかけないようにする記述


  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
