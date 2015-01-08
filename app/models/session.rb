class Session < ActiveRecord::Base
  validates :token, :user_id, presence: true
  belongs_to :user
end
