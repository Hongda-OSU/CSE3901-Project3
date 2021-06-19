# created by: Hongda Lin (Date: 6/16/2021)
require 'mechanize'
require 'nokogiri'

# created by: Hongda Lin (Date: 6/16/2021)
# Edited 6/18/2021 by Madison Graziani
#   -Added initialization for @information and edited method titles
# NOTE: Still need to add part to check if already in hash
# Edited by: 6/18/2021 by Drew Jackson
#   -Added keyword search

class Scraper
  def initialize
    @page = Page.new
    @information = Hash.new #store news title as Hash key and news link as Hash value, need to check if news title already exist in hash when store
    # Adds header news stories to @information
    @page.head_news_titles().length().times {|i| @information[@page.head_news_titles[i].to_sym] = @page.mask_newsLinks[i] }
    # Adds trending news stories to @information
    @page.trend_news_titles().length().times {|i| @information[@page.trend_news_titles[i].to_sym] = @page.trending_newsLinks[i] }
    # Adds general news stories to @information
    @page.reg_news_titles().length().times {|i| @information[@page.reg_news_titles[i].to_sym] = @page.currentPage_newsLinks[i] }
    @agent = Mechanize.new
    @news_page = nil
  end

  # Madison
  # get everything stored in @information
  def scrape_all

  end

  # Madison
  # update the mask news
  def update

  end

  # Madison
  # check same news title
  def check_sameNews

  end

  # Edited by Madison Graziani
  #   -Added parameter and edited code
  # Updates @newsPage to hold the hyperlink of the given link parameter
  def connect_page(link)
    @news_page = @agent.get link
  end

  # Madison
  # scrape the content of the news page
  def scrape_content
    @news_page
  end

  # Madison
  # scrape the time of the news page
  def scrape_time

  end

  # Madison
  # scrape the suthor of the news page
  def scrape_author

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


# created by: Hongda Lin (Date: 6/16/2021)
class Page
  attr_reader :agent, :current_page
  @@URL = "https://www.thelantern.com/campus/"
  def initialize
    @agent = Mechanize.new
    @currentPage = @agent.get @@URL
  end

  # Created (Hongda Lin, 6/16)
  # Requires: self.has_nextPage == true
  # Set @currentPage to the next page of current page
  def goto_nextPage
    next_page_link = @agent.page.links.find{|link| link.text == "Next »"}
    next_page_link.resolved_uri
    @currentPage = next_page_link.click
  end

  # Created (Hongda Lin, 6/16)
  # Requires: self.has_previousPage == true
  # Set @currentPage to the previous page of current page
  def goto_previousPage
    previous_page_link = @agent.page.links.find{|link| link.text == "« Prev"}
    previous_page_link.resolved_uri
    @currentPage = previous_page_link.click
  end

  # Created (Hongda Lin, 6/17)
  # Page navigate to the first page
  def goto_firstPage
    @currentPage = agent.get @@URL
  end

  # Created (Hongda Lin, 6/17)
  # Page navigate to the last page
  def goto_lastPage
    unless self.current_numPage == self.total_numPage
      lastPage = self.total_numPage
      lastPage_page_link = @agent.page.links.find{|link| link.text == lastPage}
      lastPage_page_link.resolved_uri
      @currentPage = lastPage_page_link.click
    end
  end

  # Created (Hongda Lin, 6/17)
  # Page navigate to the page whose number is provide as a integer
  #
  # Haven't have a good idea about it, might need to change the query section on the link
  # This is a stupid way to do it
  def goto_particularPage pageNumber
    self.goto_firstPage
    pageNumber.times do
      self.goto_nextPage
    end
  end

  # Created (Hongda Lin, 6/16)
  # Return true if there is a next page, false otherwise
  def has_nextPage?
    @agent.page.links.find{|link| link.text == "Next »"} == nil ? false : true
  end

  # Created (Hongda Lin, 6/16)
  # Return true if there is a next page, false otherwise
  def has_previousPage?
    @agent.page.links.find{|link| link.text == "« Prev"} == nil ? false : true
  end

  # Created (Hongda Lin, 6/17)
  # trending news is the three news display on the middle, only need to scrape once
  # Return the title of trending news
  def trend_news_titles
    titles = @currentPage.xpath('//h2[@class="post-title"]/a')
    arr_titles = Array.new
    titles.each_with_index {|title,index| arr_titles<<title.text if index < 3}
    arr_titles
  end

  # Created (Hongda Lin, 6/17)
  # trending news is the three news display on the middle, only need to scrape once
  # Return the links of trending news
  def trending_newsLinks
    links = @currentPage.xpath('//h2[@class="post-title"]/a/@href')
    arr_links = Array.new
    links.each_with_index {|link,index| arr_links<<link.text if index < 3}
    arr_links
  end

  # Created (Hongda Lin, 6/17)
  # mask news is the news display on the top, only need to scrape once
  # Return the title of mask news
  def head_news_titles
    titles = @currentPage.xpath('//a[@class="mask-title"]')
    arr_titles = Array.new
    titles.each {|title| arr_titles<<title.text}
    arr_titles
  end

  # Created (Hongda Lin, 6/17)
  # mask news is the news display on the top, only need to scrape once
  # Return the link of mask news
  def mask_newsLinks
    links = @currentPage.xpath('//a[@class="mask-title"]/@href')
    arr_links = Array.new
    links.each {|link| arr_links<<link.text}
    arr_links
  end

  # Created (Hongda Lin, 6/16)
  #
  # titles has class:  Nokogiri::XML::NodeSet
  # each title inside titles has class: Nokogiri::XML::Element
  #
  # Return the titles of news of current page, not include the trending news and mask news
  def reg_news_titles
    titles = @currentPage.xpath('//article[@class="post-summary post-format-standard clearfix"]//h2[@class="post-title"]/a')
    arr_titles = Array.new
    titles.each{|title| arr_titles<<title.text}
    arr_titles
  end

  # Created (Hongda Lin, 6/16)
  #
  # links has class:  Nokogiri::XML::NodeSet
  # each link inside links has class: Nokogiri::XML::Attr
  #
  # Return an array of strings (links)
  #
  # Problem: for each page the first three link are always the same
  def currentPage_newsLinks
    links = @currentPage.xpath('//article[@class="post-summary post-format-standard clearfix"]//h2[@class="post-title"]/a/@href')
    arr_links = Array.new
    links.each{|link| arr_links << link.text}
    arr_links
  end

  # Created (Hongda Lin, 6/17)
  # Return last page number
  def total_numPage
    arr_pageNumbers = @currentPage.xpath('//a[@class="page-numbers"]').to_a
    arr_pageNumbers[-1].text
  end

  # Created (Hongda Lin, 6/17)
  # Return current page number
  def current_numPage
    current_pageNumber = @currentPage.xpath('//span[@class="page-numbers current"]')
    current_pageNumber.text
  end

  # Created (Hongda Lin, 6/17)
  # Return true if current page is last page, false otherwise
  def is_lastPage?
    self.has_nextPage? ? false:true
  end

  # Created (Hongda Lin, 6/17)
  # Return true if current page is first page, false otherwise
  def is_firstPage?
    self.has_previousPage? ? false:true
  end

  # Created (Hongda Lin, 6/17)
  # Return the current page news title, for checking page navigation
  def info
    self.reg_news_titles
  end

end

#Test
#page = Page.new
#scraper = Scraper.new
#scraper.display
#puts array2
#page.goto_nextPage
#page.goto_lastPage
#puts page.has_previousPage?
#puts page.has_nextPage?
#page.goto_lastPage
#puts page.is_lastPage?
#puts page.mask_newsLinks
#r = scraper.create_regexp ['abc', 'def']
#puts r.match?('ab def')



