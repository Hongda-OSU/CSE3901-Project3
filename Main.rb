# Created 6/20/21 by Samuel Gernstetter
require_relative 'Scraper'
require_relative 'View'

scraper = Scraper.new
view = View.new
=begin
loop do
  option = view.menu_prompt.downcase
  break if option == 'quit'
  scraper.page.goto_particular_page view.page_prompt scraper.page.last_page_num if option == 'page'
end
=end
puts scraper.page.trend_news_titles
puts scraper.page.trend_news_links
puts scraper.page.trend_news