# Created 6/20/21 by Samuel Gernstetter
# Edited 6/20/21 by Samuel Gernstetter
require_relative 'Scraper'
require_relative 'View'

scraper = Scraper.new
view = View.new
loop do
  # TODO make another implementation that uses the separate view methods with corresponding altered logic (comment out old)
  page_num = scraper.page.current_page_num
  articles = scraper.page.mask_news.keys.concat scraper.page.trend_news.keys, scraper.page.reg_news.keys
  view.article_list articles, page_num
  option = view.menu_prompt.downcase
  case option
  # TODO get digit input from user, verify that it is a digit and a valid article digit, handle either way
  when 'next'
    scraper.page.has_next_page? ? scraper.page.goto_page("Next »") : view.page_error_message
  when 'previous'
    scraper.page.has_previous_page? ? scraper.page.goto_page("« Prev") : view.page_error_message
  when 'page'
    page_num = view.page_prompt scraper.page.last_page_num
    scraper.page.has_particular_page? page_num ? scraper.page.goto_particular_page(page_num) : view.page_error_message
  when 'quit'
    break
  else
    view.input_error_message
  end
end
#puts scraper.page.trend_news.keys
#puts scraper.page.trend_news.values