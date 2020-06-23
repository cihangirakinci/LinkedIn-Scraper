# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'

class JobsController < ApplicationController
  def index
    Job.destroy_all
    @first = Job.new
    driver = Selenium::WebDriver.for :firefox
    driver.get('https://www.linkedin.com/jobs/search?keywords=%22ruby%20On%20Rails%22&trk=public_jobs_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1')

    job_titles = driver.find_elements(class: 'result-card__title')
    job_links = driver.find_elements(class: 'result-card__full-card-link')

    job_titles.length.times do |i|
      job = Job.new
      job.title = job_titles[i].text
      job.link = job_links[i].attribute('href')
      job.save!
    end

    driver.quit

    @jobs = Job.all
  end
end
