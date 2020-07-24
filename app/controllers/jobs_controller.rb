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


  def new
    Job.destroy_all
    options = Selenium::WebDriver::Chrome::Options.new(args: ['-headless'])
    driver = Selenium::WebDriver.for :chrome, options: options

    driver.get('https://www.linkedin.com/jobs/search?keywords=%22ruby%20On%20Rails%22&trk=public_jobs_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1')

    job_titles = driver.find_elements(class: 'result-card__title')
    job_links = driver.find_elements(class: 'result-card__full-card-link')
    company_names = driver.find_elements(class: 'result-card__subtitle-link')
    list_date = driver.find_elements(class: 'job-result-card__listdate--new')
    job_titles.length.times do |i|
      job = Job.new
      if job_titles[i].text.include?('Senior') || job_titles[i].text.include?('Sr') || job_titles[i].text.include?('Lead') || job_titles[i].text.include?('Director')
        next
      end

      job.title = job_titles[i].text
      job.link = job_links[i].attribute('href')
      job.company = company_names[i].text
      # byebug
      job.date = (list_date[i].text || '')

      @browser = Capybara::Session.new(:selenium_chrome_headless)
      @browser.visit(job.link)

      if @browser.find('.show-more-less-html__markup')['innerHTML']
        @desc = @browser.find('.show-more-less-html__markup')['innerHTML']
      else
        next
      end
      job.description = @desc

      job.save!
    end
    redirect_to root_url
  end
end
