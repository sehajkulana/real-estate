class Report < ApplicationRecord
  belongs_to :property, optional: true
  belongs_to :reported_by, class_name: "User", optional: true
end
