# frozen_string_literal: true

# Created 6/17/21 by Samuel Gernstetter
# Methods to input and output data
class View
  # Created 6/17/21 by Samuel Gernstetter
  # print a numbered list of articles
  def article_list(articles)
    i = 1
    articles.each do |headline|
      puts "#{i}) #{headline}"
    end
  end

  # Created 6/17/21 by Samuel Gernstetter
  # prompt the user to navigate the article list
  def menu_prompt
    print "Enter an article's number to read it, or enter 'next'/'previous' to get the next/previous page, if present: "
    gets.chomp
  end

  # Created 6/17/21 by Samuel Gernstetter
  # alert the user that they attempted to access a nonexistent article
  def error_message(num)
    puts "Article ##{num} does not exist in current list. PLease enter a valid article number."
  end

  # Created 6/17/21 by Samuel Gernstetter
  # print an article and prompt the user to exit
  def print_article(headline, date, author, body)
    puts "#{headline}\n#{date}\n#{author}\n#{body}"
    print 'Enter any input when finished reading to return to the list.'
    gets.chomp
  end
end
