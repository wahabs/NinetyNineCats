class Cat < ActiveRecord::Base
  COLORS = %w(Brown Black Blue)

  validates :name, :sex, :color, :birth_date, presence: true
  validates :name, uniqueness: true
  validates :color, inclusion: { in: COLORS,
    message: "%{value} is not a valid color" }
  validates :sex, inclusion: { in: %w(M F), message: "Not a valid sex" }

  has_many :cat_rental_requests, dependent: :destroy

  def age
    now = Time.now.utc.to_date
    now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end

end
