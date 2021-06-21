# Created 6/20/21 by Samuel Gernstetter
require_relative 'Scraper'
require_relative 'View'

scraper = Scraper.new
view = View.new
loop do
  option = view.menu_prompt.downcase
  case option
  when 'next'
    scraper.page.has_next_page? ? scraper.page.goto_page "Next »" : view.page_error_message
  when 'previous'
    scraper.page.has_previous_page? ? scraper.page.goto_page "« Prev" : view.page_error_message
  when 'page'
    page_num = view.page_prompt scraper.page.last_page_num
    scraper.page.has_particular_page? page_num ? scraper.page.goto_particular_page page_num : view.page_error_message
  when 'quit'
    break
  end
end
#puts scraper.page.trend_news.keys
#puts scraper.page.trend_news.values