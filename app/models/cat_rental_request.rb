require 'byebug'
class CatRentalRequest < ActiveRecord::Base
  STATUSES = %w(PENDING APPROVED DENIED)
  before_validation :set_status_to_pending
  validates :start_date, :end_date, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :no_overlapping_approved_requests?
  belongs_to :cat


  def deny!
    self.status = "DENIED"
    self.save!
  end

  def approve!
    self.status = "APPROVED"
    save!
    overlapping_pending_requests.each(&:deny!)
  end

  def pending?
    self.status == "PENDING"
  end

  private

    def no_overlapping_approved_requests?
      unless overlapping_approved_requests.empty?
        errors[:status] << "There are overlapping approved requests"
      end
    end

    def overlapping_approved_requests
      overlapping_requests
      .select("cat_rental_requests.*")
      .where("status = ?", "APPROVED")
    end

    def overlapping_pending_requests
      overlapping_requests
      .select("cat_rental_requests.*")
      .where("status = ?", "PENDING")
    end

    def overlapping_requests
    #  byebug
      Cat.find(cat_id)
      .cat_rental_requests
      .select("cat_rental_requests.*")
      .where("start_date <> ? AND start_date < ?", start_date, end_date)
    end

    def set_status_to_pending
      self.status ||= "PENDING"
    end
end
