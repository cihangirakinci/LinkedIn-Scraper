# frozen_string_literal: true

class ScrapeLinkedin
  def perform
    set_up_selenium!
    @driver.get('https://www.linkedin.com/jobs/search?keywords=%22ruby%20On%20Rails%22&trk=public_jobs_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1')

    find_elements!

    @job_titles.length.times do |title|
      next if @job_titles[title].text.include?('Senior') || @job_titles[title].text.include?('Sr') || @job_titles[title].text.include?('Lead') || @job_titles[title].text.include?('Director')
      next unless @company_names[title]

      browser = Capybara::Session.new(:selenium_chrome_headless)
      browser.visit(@job_links[title].attribute('href'))
      next unless browser.has_css?('.show-more-less-html__markup')

      desc = browser.find('.show-more-less-html__markup')['innerHTML']
      create_job!(title, desc)
    end
  end

  private

  def create_job!(title, desc)
    job = Job.new
    job.title = @job_titles[title].text
    job.link = @job_links[title].attribute('href')
    job.company = @company_names[title].text
    job.description = desc
    job.date = Date.today
    job.save!
  end

  def set_up_selenium!
    options = Selenium::WebDriver::Chrome::Options.new(args: ['-headless'])
    @driver = Selenium::WebDriver.for :chrome, options: options
  end

  def find_elements!
    @job_titles = @driver.find_elements(class: 'result-card__title')
    @job_links = @driver.find_elements(class: 'result-card__full-card-link')
    @company_names = @driver.find_elements(class: 'result-card__subtitle-link')
  end
end
