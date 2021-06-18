# frozen_string_literal: true

# Methods to input and output data
class View
  # print a numbered list of articles
  def article_list(articles)
    i = 1
    articles.each do |headline|
      puts "#{i}) #{headline}"
    end
  end

  # prompt the user to navigate the article list
  def menu_prompt
    print "Enter an article's number to read it, or enter 'next'/'previous' to get the next/previous page, if present: "
    gets.chomp
  end

  # print an article and prompt the user to exit
  def print_article(headline, date, author, )
end
