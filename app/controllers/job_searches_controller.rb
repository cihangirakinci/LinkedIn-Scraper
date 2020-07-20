# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'
require 'capybara'
require 'open-uri'
require 'active_support/core_ext/date'
require 'date'

class JobSearchesController < ApplicationController
  def new
    job = Job.new

    url = 'https://www.linkedin.com/jobs/search?keywords=%22ruby%20On%20Rails%22&trk=public_jobs_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1'

    response = Faraday.get(url) do |request|
      request.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
    end

    driver = Nokogiri::HTML(response.body)

    job_titles = driver.css('.result-card__title')
    #byebug
    job_links = driver.css('.result-card__full-card-link')
    company_names = driver.css('.result-card__subtitle-link')
    job_titles.length.times do |i|
      job = Job.new
      #byebug
      #next if job_titles[i].text.include?('Senior') || job_titles[i].text.include?('Sr') || job_titles[i].text.include?('Lead') || job_titles[i].text.include?('Director')

      job.title = job_titles[i].text
      job.link = job_links[i].attribute('href')
      if company_names[i]
        job.company = company_names[i].text
      else
        next
      end

      driver2 = Faraday.get(job.link) 
      browser = Nokogiri::HTML(driver2.body)

      if browser.css('.show-more-less-html__markup')
        @desc = browser.css('.show-more-less-html__markup')
      else
        next
      end

      job.description = @desc
      job.date = Date.today
      job.save!
      
    end

      
  end
  
end
