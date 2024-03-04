class Message < ApplicationRecord
  # DM 機能の
  belongs_to :user
  belongs_to :room
  
  validates :message, presence: true, length: { maximum: 140 }
  #メッセージが空欄はNG、かつ140字以内
end
