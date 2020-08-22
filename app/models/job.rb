# frozen_string_literal: true

class Job < ApplicationRecord
    validates :deleted, inclusion: { in: [true, false] }
end
