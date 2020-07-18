# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'open-uri'
require 'active_support/core_ext/date'
require 'date'

class JobsController < ApplicationController
  def index
    @jobs = Job.all
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to root_url
  end
end
