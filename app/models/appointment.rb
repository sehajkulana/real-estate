class Appointment < ApplicationRecord
  belongs_to :property
  belongs_to :buyer
  belongs_to :seller
end
