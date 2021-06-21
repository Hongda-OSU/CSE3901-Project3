# frozen_string_literal: true

# TODO might not need to be a class - module?
# TODO add variable definitions
# Created 6/17/21 by Samuel Gernstetter
# Methods to input and output data
class View
  # TODO make split up versions of article_list for the three news types
  # Created 6/17/21 by Samuel Gernstetter
  # Edited 6/19/21 by Samuel Gernstetter
  #   merge article_list and search_results
  # print a numbered list of articles on a page
  def article_list(articles, *page_num)
    if page_num.length > 0
      puts "Page #{page_num[0]}"
    else
      puts 'Search Results:'
    end
    num = 1
    articles.each do |headline|
      puts "#{num}) #{headline}"
      num = num + 1
    end
  end

  # Created 6/17/21 by Samuel Gernstetter
  # Edited 6/18/21 by Drew Jackson
  #   added search option to prompt
  # Edited 6/21/21 by Drew Jackson
  #   print to puts
  # prompt the user to navigate the article list
  def menu_prompt
    puts "\nEnter an article's number to read it, enter 'next'/'previous' to go to"
    puts "the next/previous page if present, enter 'page' to go to a specific"
    puts "page, enter 'search' to search articles, or enter 'quit' to exit the,"
    print "program: "
    gets.chomp!
  end

  # Created 6/19/21 by Samuel Gernstetter
  # prompt the user to select a page number
  def page_prompt(last_page_num)
    print "Enter a page number to go to that page of articles (1-#{last_page_num}): "
    gets.chomp!
  end

  # Created 6/17/21 by Samuel Gernstetter
  # alert the user that they attempted to access a nonexistent article
  def article_error_message(num)
    puts "WARNING: Article ##{num} does not exist in current list. PLease enter a valid article number."
  end

  # Created 6/17/21 by Samuel Gernstetter
  # alert the user that they attempted to access a nonexistent page
  def input_error_message
    puts 'WARNING: Attempted to access nonexistent page.'
  end

  # Created 6/20/21 by Samuel Gernstetter
  # alert the user that they entered an invalid input
  def page_error_message
    puts 'WARNING: Invalid input.'
  end

  # Created 6/17/21 by Samuel Gernstetter
  # print an article and prompt the user to exit
  def print_article(headline, date, author, body)
    puts "#{headline}\n#{date}\n#{author}\n#{body}"
    print 'Enter any input when finished reading to return to the list.'
    gets.chomp!
  end

  # Created 6/17/21 by Drew Jackson
  # Edited 6/20/21 by Samuel Gernstetter
  #   change name to search_prompt
  # Prompt user for a keyword to search for
  def search_prompt
    print "Enter search term: "
    gets.chomp!
  end
end
