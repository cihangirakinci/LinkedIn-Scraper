# frozen_string_literal: true

require 'nokogiri'
require 'date'

class JobsController < ApplicationController
  def index
    @jobs = Job.all
  end

  def new
    if ScrapeLinkedin.new.perform
      redirect_to root_url
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to root_url
  end
end
