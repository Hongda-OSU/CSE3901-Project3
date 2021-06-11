require 'mechanize'
require 'nokogiri' #not used
require 'open-uri' #not used


class Scraper
  URL = "https://cse.osu.edu/course-coordinators"
  def initialize
    @agent = Mechanize.new
    @page = @agent.get URL
  end

end
agent = Mechanize.new
page = agent.get "https://cse.osu.edu/course-coordinators"

#document = Nokogiri::HTML.parse(open("https://cse.osu.edu/course-coordinators"))

information = Hash.new
titles = page.xpath("//th") # or use titles = page.css("th")
titles.each do |title|
  information[title.text.intern] = []
end

num_title = information.length

bodies = page.xpath("//td")
bodies.each_with_index do |body, index|
    information[information.keys[index % num_title]] << body.text
end

print information