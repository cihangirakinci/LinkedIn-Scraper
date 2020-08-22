# frozen_string_literal: true

class ApplicationController < ActionController::Base

    helper_method :jobs_active

    def jobs_active
        @jobs = Job.where(deleted: :false)
    end
end
