class Entry < ApplicationRecord
  # DM 機能の実装
  belongs_to :user
  belongs_to :room
end
