# frozen_string_literal: true
require 'open-uri'

class ScrapeLinkedin
  def perform

    set_up_watir_nokogiri

    find_elements!

    @job_titles.length.times do |title|
      next if @job_titles[title].text.include?('Senior') || @job_titles[title].text.include?('Sr') || @job_titles[title].text.include?('Lead') || @job_titles[title].text.include?('Director')
      next unless @company_names[title]
      next if Job.find_by(link: @job_links[title].attribute('href').value.split('?')[0])
      
      url = @job_links[title].attribute('href').value
      explore = Faraday.get(url) do |request|
        request.headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
      end

      browser = Nokogiri::HTML.parse(explore.body)
      next unless browser.css('.show-more-less-html__markup')
      desc = browser.css('.show-more-less-html__markup').inner_html
      create_job!(title, desc)

    end
  end

  private

  def create_job!(title, desc)
    job = Job.new
    job.title = @job_titles[title].text
    job.link = @job_links[title].attribute('href').value.split('?')[0]
    job.company = @company_names[title].text
    job.description = desc
    job.date = Date.today
    job.save!
  end

  def set_up_watir_nokogiri
    url = 'https://www.linkedin.com/jobs/search?keywords=%22ruby%20On%20Rails%22&trk=public_jobs_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1'
    explore = Faraday.get url

    @driver = Nokogiri::HTML.parse(explore.body)
  end

  def find_elements!
    @job_titles = @driver.css('.result-card__title')
    @job_links = @driver.css('.result-card__full-card-link')
    @company_names = @driver.css('.result-card__subtitle-link')
  end
end
