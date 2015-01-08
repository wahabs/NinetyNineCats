class Session < ActiveRecord::Base
  validates :token, presence: true
  # after_initialize :ensure_session_token
  belongs_to :user


end
