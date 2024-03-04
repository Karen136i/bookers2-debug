class Room < ApplicationRecord
  # DM 機能の実装
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
end
