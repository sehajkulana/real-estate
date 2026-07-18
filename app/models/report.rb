class Report < ApplicationRecord
  belongs_to :property
  belongs_to :reported_by, class_name: "User"
end
