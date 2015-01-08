require 'bcrypt'

class User < ActiveRecord::Base
  validates :user_name, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :password_digest, presence: { message: "Password can't be blank"}
  # after_initialize :ensure_session_token

  has_many :cats
  has_many :sessions, dependent: :destroy
  has_many(
    :requests,
    class_name: 'CatRentalRequest',
    foreign_key: :user_id,
    primary_key: :id
  )

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return nil if user.nil?
    (user.is_password?(password)) ? user : nil
  end


  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end




  private

  # def ensure_session_token
  #   unless self.sessions.pluck(:token).include?(session[:session_token])
  #     Session.create(token: SecureRandom::urlsafe_base64, user_id: self.id)
  #   end
  #   #self.session_token ||= SecureRandom::urlsafe_base64
  # end

end
