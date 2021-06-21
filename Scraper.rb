# created by: Hongda Lin (Date: 6/16/2021)
require 'mechanize'
require 'nokogiri'
require_relative 'Page'

# Created by Hongda Lin (Date: 6/16/2021)
# Edited 6/18/2021 by Madison Graziani
#   -Added initialization for @information and added comments and method code
# Edited by: 6/18/2021 by Drew Jackson
#   -Added keyword search
# Edited by: 6/20/2021 by Hongda Lin
#   -Scraper class only scrape the current page news and store them in different hash, when goto_next/previous page, these hash will
#   be update to news in that new page. User could choose to see mask news, trend news or page news by enter number (View), the titles
#   will be displayed and user could choose an article by number to see the content.
class Scraper
  attr_reader :page, :mask_news, :trend_news, :reg_news, :news_page
  def initialize
    @page = Page.new
    #Store the current page mask news titles and links as a hash, num 2
    @mask_news = nil
    #Store the current page trend news titles and links as a hash, num 3
    @trend_news = nil
    #Store the current page reg news titles and links as a hash, num 12
    @reg_news = nil
    @agent = Mechanize.new
    #Webpage of one article
    @news_page = nil
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  #   -Changed code to loop and get all pages
  # Edited by Hongda Lin on 6/20/2021
  #   -Reverted code to one page with no duplicate check
  # Edited by Madison Graziani on 6/20/2021
  #   -Changed parameter name and simplified code
  # Fills @mask_news with article titles and links
  def scrape_mask_news
    # Resets hash to take info from new page
    @mask_news = @page.mask_news
    #@mask_news = Hash.new
    #@page.mask_news.keys.length.times {|index| @mask_news[@page.mask_news.keys[index].to_sym] = @page.mask_news.values[index]}
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  #   -Changed code to loop and get all pages
  # Edited by Hongda Lin on 6/20/2021
  #   -Reverted code to one page with no duplicate check
  # Edited by Madison Graziani on 6/20/2021
  #   -Changed parameter name and simplified code
  # Fills @trend_news with article titles and links
  def scrape_trend_news
    # Resets hash to take info from new page
    @trend_news = @page.trend_news
    #@trend_news = Hash.new
    #@page.trend_news.keys.length.times {|index| @trend_news[@page.trend_news.keys[index].to_sym] = @page.trend_news.values[index]}
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  #   -Changed code to loop and get all pages
  # Edited by Hongda Lin on 6/20/2021
  #   -Reverted code to one page with no duplicate check
  # Edited by Madison Graziani on 6/20/2021
  #   -Changed parameter name and simplified code
  # Fills @reg_news with article titles and links
  def scrape_reg_news
    # Resets hash to take info from new page
    @reg_news = @page.reg_news
    #@reg_news = Hash.new
    #@reg.reg_news.keys.length.times {|index| @reg_news[@page.reg_news.keys[index].to_sym] = @page.reg_news.values[index]}
  end

  #Edited by Madison Graziani on 6/20/2021
  #   -Added original version of code
  # This method searches the specified hash for the correct link to a specified news article
  # @param choice
  #       An integer specifying the type of news
  # @param title
  #       A string that is the title of a news story
  def get_link choice, title
    case choice
    when 1
      @mask_news[title.to_sym]
    when 2
      @trend_news[title.to_sym]
    when 3
      @reg_news[title.to_sym]
    end
  end

  # Created by Hongda Lin on 6/20/2021
  # @param choice1
  #       choice1 is the integer user enter in the first menu for select what kind of news
  # @param choice2
  #       choice2 is the integer in second menu for what news they want to look.
  #
  # @return a specific news title, will be used in get_link
  def get_title choice1, choice2
    case choice1
    when 1
      @mask_news.keys[choice2].to_s
    when 2
      @trend_news.keys[choice2].to_s
    when 3
      @reg_news.keys[choice2].to_s
    end
  end

  #Edited by Hongda Lin on 6/20/2021
  #   -Added original version of code
  # This method prints the specified hash of news titles
  # @param choice
  #       An integer specifying the type of news
  def list_news choice
    case choice
    when 1
      @mask_news.each_key { |key| puts key  }
    when 2
      @trend_news.each_key { |key| puts key  }
    when 3
      @reg_news.each_key { |key| puts key  }
    end
  end

  # Edited by Madison Graziani on 6/18/2021
  #   -Added parameter and edited code
  # Updates @news_page to hold the hyperlink of the given link parameter
  def connect_page link
    @news_page = @agent.get link
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  # Edited 6/19/21 by Samuel Gernstetter
  # Scrapes the contents of the news page and returns it as text
  def scrape_content
    #connect_page(@information[:"Ohio Union now accepting space requests for fall semester"])
    contents = @news_page.xpath('//section/p').to_a
    #Debug print
    #contents.each { |content| puts content.text }
  end

  # Edited by Madison Graziani on 6/18/2021
  #   -Added the original version of code
  # Edited 6/19/21 by Samuel Gernstetter
  # Scrapes the date the article was published and returns it as text
  def scrape_date
    #connect_page(@information[:"Ohio Union now accepting space requests for fall semester"])
    @news_page.xpath('//li[@class="post-date"]').text
  end

  # Edited by Madison Graziani on 6/18/2021
  #   -Added the original version of code
  # Edited 6/19/21 by Samuel Gernstetter
  # Scrapes the name of the article's author and returns it as text
  def scrape_author
    #connect_page(@information[:"Ohio Union now accepting space requests for fall semester"])
    @news_page.xpath('//li[@class="post-author"]/a').text
  end


  #
  # (1)there are three way user could choice, use Date: Year, Month, *Day (optional), display a list of news, ask which news they to see(integer), go page, scrape page content down, display to use
  # (2)prompt for key words, find the news title contains that keyword, and repeat
  # Created by Drew Jackson 6/17/21
  # @param terms
  #   an array of search terms entered by the user
  # @return
  #   a hash of title/link key/value pairs of articles containing search terms
  # TODO use RegExp to be case insensitive
  def keyword_search *terms
    matches = Array.new
    regx = create_regexp terms
    information = page.mask_news.merge page.trend_news
    pages = 0

    until matches.length == 10 || pages == 5 || !page.has_next_page?
      pages += 1
      page.goto_page("Next »")
      information.merge page.reg_news

      # Search titles for key words
      information.each_key{|title| matches.push(title.to_s) if regx.match(title.to_s)}

      #search unmatched articles text for key words
      remaining = information.reject{|key| matches.include?(key.to_s)}
      remaining.each_value{|link| matches.push(remaining.key(link)) if search_news_text(link, regx)}
    end
    #return hash of matched articles
    information.select{|key| matches.include?(key.to_s)}
  end

  # Created by Drew Jackson 6/17/2021
  # Scans an article for keywords, returns true if matched
  # @param link
  #   The link to the article to be scanned
  # @param regx
  #   The regular expression which the article will be scanned against
  # @return
  #   A boolean value, true if matches to regx are found, false if not
  def search_news_text link, regx
    connect_page link
    content = scrape_content
    # RegExp to search content for keywords
    # TODO match to format of content_scrape return

    # Edit changed each to any?, short circuits search
    content.any?{|text| regx.match?(text)}
  end

  # Created by Drew Jackson 6/18/21
  # Takes a list of search terms and returns an all encompassing Regexp
  # @param term
  #   an array of search terms given by the user
  # @return
  #   a single regular expression to cover all search terms
  def create_regexp term
    #TODO update to case insensitive
    Regexp.union(term)
  end

  # (3)Randomly generate a list of titles, and repeat
  # A view to make a interaction between user and Scraper
  # Possibly: GUI

end

scraper = Scraper.new
scraper.scrape_reg_news
title =  scraper.get_title 3, 1 #3 means reg_news. 1-1 means first article because of hash
link = scraper.get_link 3, title
scraper.connect_page link
scraper.scrape_content


