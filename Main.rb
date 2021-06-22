# Created 6/20/21 by Samuel Gernstetter
# Edited 6/20/21 by Samuel Gernstetter
require_relative 'Scraper'
require_relative 'View'

#TODO comments and remove view arg after class removed
def print_num_article scraper, articles, option, view
  option = option.to_i
  if option > 0
    if option <= articles.keys.length
      scraper.connect_page articles.values[option - 1]
      headline = articles.keys[option - 1]
      date = scraper.scrape_date
      author = scraper.scrape_author
      body = scraper.scrape_body
      view.print_article headline, date, author, body
      option = 'continue'
    else
      view.article_error_message option
    end
  else
    view.input_error_message
  end
end

scraper = Scraper.new
view = View.new

#TODO start with main menu of option before printing article list
option = view.main_menu_prompt.downcase

loop do
  if option == 'continue'
    #TODO maybe start loop with gets and pass to option before printing list
    #TODO make another implementation that uses the separate view methods with corresponding altered logic (comment out old)
    page_num = scraper.page.current_page_num
    #TODO move mask/trend scrape out of loop to stop duplicate posts
    articles = scraper.page.mask_news.merge scraper.page.trend_news, scraper.page.reg_news
    view.article_list articles.keys, page_num
    option = view.menu_prompt.downcase
  end
  case option
  # TODO get digit input from user, verify that it is a digit and a valid article digit, handle either way
  when 'next'
    scraper.page.has_next_page? ? scraper.page.goto_page("Next »") : view.page_error_message
    option = 'continue'
  when 'previous'
    scraper.page.has_previous_page? ? scraper.page.goto_page("« Prev") : view.page_error_message
    option = 'continue'
  when 'page'
    #TODO has_particular_page not working, what is being passed in
    page_num = view.page_prompt scraper.page.last_page_num
    scraper.page.has_particular_page?(page_num) ? scraper.page.goto_particular_page(page_num) : view.page_error_message
    option = 'continue'
  when 'search'
    # Created by Drew Jackson 6/21/21
    #TODO loop on search, present results from first X pages, prompt user for next page of results or quit.

    #TODO no results error message
    # search through X pages of articles for matches to keywords
    results = {}
    results.merge! scraper.keyword_search view.search_prompt
    until option == 'exit'
     if results.length > 0
       view.search_results results
       view.search_result_menu
       option = gets.chomp!
      else
        view.no_search_results
        option = gets.chomp!
     end
     if option.to_i > 0 && option.to_i <= results.length
       print_num_article scraper, results, option, view
       #TODO what returned and processed by loop
     end
    end
    #search_page = scraper.page.current_page

    # return article list to prior position
    scraper.page.goto_particular_page page_num
    #option = 'continue'
  when 'quit'
    break
  else
    print_num_article scraper, articles, option, view
    option = 'continue'
=begin
    option = option.to_i
    if option > 0
      if option <= articles.keys.length
        scraper.connect_page articles.values[option - 1]
        headline = articles.keys[option - 1]
        date = scraper.scrape_date
        author = scraper.scrape_author
        body = scraper.scrape_body
        view.print_article headline, date, author, body
        option = 'continue'
      else
        view.article_error_message option
      end
    else
      view.input_error_message
    end
=end
  end
  #option = view.menu_prompt.downcase
end

