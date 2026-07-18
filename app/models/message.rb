class Message < ApplicationRecord
  belongs_to :sender
  belongs_to :receiver
  belongs_to :property
end
