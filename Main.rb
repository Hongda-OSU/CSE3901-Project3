# Created 6/20/21 by Samuel Gernstetter
# Edited 6/20/21 by Samuel Gernstetter
require_relative 'Scraper'
require_relative 'View'

# Created by Drew Jackson 6/22/2021
# prints the selected article for the user
def print_num_article scraper, articles, option, view
  option = option.to_i
  if option > 0
    if option <= articles.keys.length
      link = articles.values[option - 1]
      scraper.connect_page link
      headline = articles.keys[option - 1]
      date = scraper.scrape_date
      author = scraper.scrape_author
      body = scraper.scrape_body
      if body != ""
        view.print_article headline, date, author, body
      else
        view.scrape_error_message link
      end
    else
      view.article_error_message option
    end
  else
    view.input_error_message
  end
end

scraper = Scraper.new
view = View.new
# greet user and prompt for action
option = nil
until option == 'search' || option == 'continue' || option == 'quit'
  option = view.main_menu_prompt.downcase
  view.main_menu_invalid unless option == 'search' || option == 'continue' || option == 'quit'
end

# run program until user quits
loop do
  #scrape page content and display menu
  if option == 'continue'
    page_num = scraper.page.current_page_num
    articles = scraper.page.mask_news.merge scraper.page.trend_news, scraper.page.reg_news
    view.article_list articles.keys, page_num
    option = view.menu_prompt.downcase
  end

  # process user requests
  case option
  # scrape and present next page from website
  when 'next'
    scraper.page.has_next_page? ? scraper.page.goto_page("Next »") : view.page_error_message
    option = 'continue'
  # scrape and present the previous page from website
  when 'previous'
    scraper.page.has_previous_page? ? scraper.page.goto_page("« Prev") : view.page_error_message
    option = 'continue'
  # scrape and present requested page number
  when 'page'
    page_num = view.page_prompt scraper.page.last_page_num
    scraper.page.has_particular_page?(page_num) ? scraper.page.goto_particular_page(page_num) : view.page_error_message
    option = 'continue'
  # search articles for mentions of keywords and present results
  when 'search'
    # Created by Drew Jackson 6/21/21

    # search through X pages of articles for matches to keywords
    results = {}
    term = view.search_prompt
    until option == 'exit'
      # add each new round off search to previous results
      results.merge! scraper.keyword_search term
      # if matches found present list
      if results.length > 0
        view.search_results results
        option = view.search_result_menu
      # else inform user of no matches and prompt for action
      else
        option = view.no_search_results
      end

      # if user enters article number print article text
      if option.to_i > 0 && option.to_i <= results.length
        print_num_article scraper, results, option, view
        #TODO what returned and processed by loop
      end

      # collect new search term if user wants to perform new search
      if option == 'search'
        term = view.search_prompt
        #clear results from previous searches
        results = {}
      end

     # present results to user
     if results.length > 0
       view.search_results results
       option = view.search_result_menu
     else
       option = view.no_search_results
     end
     if option.to_i > 0 && option.to_i <= results.length
       print_num_article scraper, results, option, view
     end
    end

    # return article list to prior position for smooth return
    if !page_num.nil? && page_num > 0
      scraper.page.goto_particular_page page_num
    else
      scraper.page.goto_particular_page 1
    end
    option = 'continue'
  # exit program
  when 'quit'
    break
  # print requested article for user
  else
    print_num_article scraper, articles, option, view
    option = 'continue'
  end
end

