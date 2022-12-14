class Task < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
  belongs_to :user
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  private

    def validate_name_not_including_comma
      errors.add(:name, "にカンマを含めることはできません") if name&.include?(",")
    end
end
