class Message < ApplicationRecord
  enum message_type: [ :send_text, :send_emotion ]

  validates :message_type, inclusion: { in: message_types.keys }
  validates :payload, presence: true
  validates :payload, length: { maximum: 160 },
                      if: :send_text?
  validates :payload, length: { minimum: 2, maximum: 10 },
                      format: { with: /\A(?:[^\d])*\z/, message: "no numbers allowed" },
                      if: :send_emotion?
end
