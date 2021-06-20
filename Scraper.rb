# created by: Hongda Lin (Date: 6/16/2021)
require 'mechanize'
require 'nokogiri'

# Created by Hongda Lin (Date: 6/16/2021)
# Edited 6/18/2021 by Madison Graziani
#   -Added initialization for @information and added comments and method code
# Edited by: 6/18/2021 by Drew Jackson
#   -Added keyword search
class Scraper
  def initialize
    @page = Page.new
    #Stores article titles and their respective links as Hash pairs
    @information = Hash.new
    @agent = Mechanize.new
    #Webpage of one article
    @news_page = nil
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  #   -Changed code to loop and get all pages
  # Fills @information with article titles and links while making sure to check for duplicates
  def scrape_all
    # Adds header news stories to @information
    @page.mask_news_titles().length().times {|i| unless duplicate_title?(@page.mask_news_titles[i])
                                                     @information[@page.mask_news_titles[i].to_sym] = @page.mask_news_links[i] end}
    # Adds trending news stories to @information
    @page.trend_news_titles().length().times {|i| unless duplicate_title?(@page.trend_news_titles[i])
                                                    @information[@page.trend_news_titles[i].to_sym] = @page.trend_news_links[i] end}
    until @page.is_lastPage?
      # Adds general news stories to @information
      @page.reg_news_titles().length().times {|i| unless duplicate_title?(@page.reg_news_titles[i])
                                                    @information[@page.reg_news_titles[i].to_sym] = @page.reg_news_links[i] end}
      @page.goto_nextPage
    end
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  # Updates @information if there are new mask articles
  def update_mask_news
    news_array = @page.mask_news_titles
    news_links = @page.mask_news_links
    news_array.length().times {|i| unless duplicate_title?(news_array[i])
                                     @information[news_array[i].to_sym] = news_links[i] end}
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  # Checks if an article title already exists in @information
  def duplicate_title?(title)
    @information.has_key? title
  end

  # Edited by Madison Graziani on 6/18/2021
  #   -Added parameter and edited code
  # Updates @newsPage to hold the hyperlink of the given link parameter
  def connect_page(link)
    @news_page = @agent.get link
  end

  # Edited by Madison Graziani on 6/19/2021
  #   -Added the original version of code
  # Edited 6/19/21 by Samuel Gernstetter
  # Scrapes the contents of the news page and returns it as text
  def scrape_content
    #connect_page(@information[:"Ohio Union now accepting space requests for fall semester"])
    @news_page.xpath('//section/p').text
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

  # display the news, search format (1)
  def list_news year, month, time = nil

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

    # Search titles for key words
    @information.each_key{|title| matches.push(title) if regx.match(title)}

    #search unmatched articles text for key words
    remaining = @information.reject{|key| matches.include?(key.to_s)}
    remaining.each_value{|link| matches.push(remaining.key(link)) if search_news_text(link, regx)}

    #return hash of matched articles
    @information.select{|key| matches.include?(key.to_s)}
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
    regx.match?(content)
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


#Test
#page = Page.new
#scraper = Scraper.new
#scraper.scrape_all
#page.goto_nextPage
#page.goto_lastPage
#puts page.has_previousPage?
#puts page.has_nextPage?
#page.goto_lastPage
#puts page.is_lastPage?
#puts page.mask_news_links
#r = scraper.create_regexp ['abc', 'def']
#puts r.match?('ab def')



