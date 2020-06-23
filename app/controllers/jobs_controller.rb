require 'selenium-webdriver'

class JobsController < ApplicationController
    
    def index
        @first = Job.new
        driver = Selenium::WebDriver.for :firefox
        driver.get('https://www.linkedin.com/jobs/search?keywords=%22ruby%20On%20Rails%22&trk=public_jobs_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1')
        @job_titles =  driver.find_elements(class:"result-card__title")
        #byebug
        job_titles.each do |job|
            

        end
        @first.title = job_title.text
        @first.save!
        driver.quit
    end
end
