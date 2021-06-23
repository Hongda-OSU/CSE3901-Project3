# frozen_string_literal: true

# TODO add variable definitions
# Created 6/17/21 by Samuel Gernstetter
# Methods to input and output data
class View
  # Created 6/17/21 by Samuel Gernstetter
  # Edited 6/19/21 by Samuel Gernstetter
  #   merge article_list and search_results
  # Edited 6/22/21 by Samuel Gernstetter
  #   split output by article type
  # print a numbered list of articles on a page
  def article_list(articles, page_num)
    puts "\nPage #{page_num}"
    puts "\nTop News:"
    (0..1).each { |index| puts "#{index + 1}) #{articles[index]}" }
    puts "\nTrending News:"
    (2..4).each { |index| puts "#{index + 1}) #{articles[index]}" }
    puts "\nRegular News:"
    (5..articles.length - 1).each { |index| puts "#{index + 1}) #{articles[index]}" }
  end

  # Created 6/22/21 by Samuel Gernstetter
  # print a numbered list of search results on a page
  def search_results(articles)
    puts "\nSearch Results:"
    articles.each.with_index(1) { |headline, index| puts "#{index}) #{headline}" }
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
    print "\nEnter a page number to go to that page of articles (1 - #{last_page_num}): "
    gets.chomp!.to_i
  end

  # Created 6/17/21 by Samuel Gernstetter
  # alert the user that they attempted to access a nonexistent article
  def article_error_message(num)
    puts "\nWARNING: Article ##{num} does not exist in current list. PLease enter a valid article number.\n"
  end

  # Created 6/17/21 by Samuel Gernstetter
  # alert the user that they attempted to access a nonexistent page
  def page_error_message
    puts "\nWARNING: Attempted to access nonexistent page or enter alphabetical characters as a page number. Aborting.\n"
  end

  # Created 6/20/21 by Samuel Gernstetter
  # alert the user that they entered an invalid input
  def input_error_message
    puts "\nWARNING: Invalid input.\n"
  end

  # Created 6/17/21 by Samuel Gernstetter
  # Edited 6/22/21 by Samuel Gernstetter
  #   formatting and finishing fixes
  # print an article and prompt the user to exit
  def print_article(headline, date, author, body)
    puts "\n#{headline}\n#{date}\n#{author}\n\n#{body}"
    print "Enter any input when finished reading to return to the list. "
    gets
  end

  # Created 6/17/21 by Drew Jackson
  # Edited 6/20/21 by Samuel Gernstetter
  #   change name to search_prompt
  # Prompt user for a keyword to search for
  def search_prompt
    print "\nEnter search term: "
    gets.chomp!
  end

  #Created by Drew Jackson on 6/22/2021
  # Prints menu after returning search results
  def search_result_menu
    puts "\nEnter article number to print article text or click on link to go to that page,"
    puts "enter 'next' to search for more results, enter 'search' to perform a new search,"
    puts "or enter 'exit' to return to article menu: "
  end

  #Created by Drew Jackson on 6/22/2021
  # Prints menu if no search results found.
  def no_search_results
    puts "\nNo results found in this search. If you would like to search further back through"
    print "articles enter 'continue', or enter 'exit' to return to article menu: "
  end


  # Created 6/22/21 by Drew Jackson
  # prompt the user with a main menu on start up
  def main_menu_prompt
    puts "\nWelcome! Please continue to be connected with news articles from The Lantern"
    puts "Enter 'continue' to view a list of articles, enter 'page' to go to a"
    puts "specific page, enter 'search' to search articles, or enter 'quit' to exit the"
    print "program: "
    gets.chomp!
  end
end
