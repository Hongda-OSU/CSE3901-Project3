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

  # Madison
  # Fills @information with article titles and links while making sure to check for duplicates
  def scrape_all
    # Adds header news stories to @information
    @page.mask_news_titles().length().times {|i| unless duplicate_title?(@page.mask_news_titles[i])
                                                     @information[@page.mask_news_titles[i].to_sym] = @page.mask_news_links[i] end}
    # Adds trending news stories to @information
    @page.trend_news_titles().length().times {|i| unless duplicate_title?(@page.trend_news_titles[i])
                                                    @information[@page.trend_news_titles[i].to_sym] = @page.trend_news_links[i] end}
    # Adds general news stories to @information
    @page.reg_news_titles().length().times {|i| unless duplicate_title?(@page.reg_news_titles[i])
                                                  @information[@page.reg_news_titles[i].to_sym] = @page.reg_news_links[i] end}
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
  # Scrapes the contents of the news page and returns it as text
  def scrape_content
    #connect_page(@information[:"Ohio Union now accepting space requests for fall semester"])
    content = @news_page.xpath('//section/p')
    content.text
  end

  # Edited by Madison Graziani on 6/18/2021
  #   -Added the original version of code
  # Scrapes the date the article was published and returns it as text
  def scrape_date
    #connect_page(@information[:"Ohio Union now accepting space requests for fall semester"])
    date = @news_page.xpath('//li[@class="post-date"]')
    date.text
  end

  # Edited by Madison Graziani on 6/18/2021
  #   -Added the original version of code
  # Scrapes the name of the article's author and returns it as text
  def scrape_author
    #connect_page(@information[:"Ohio Union now accepting space requests for fall semester"])
    author = @news_page.xpath('//li[@class="post-author"]/a')
    author.text
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
  # Requires:
  #   self.has_nextPage == true
  # Set:
  #   @currentPage to the next page of current page
  def goto_nextPage
    next_page_link = @agent.page.links.find{|link| link.text == "Next »"}
    next_page_link.resolved_uri
    @currentPage = next_page_link.click
  end

  # Created (Hongda Lin, 6/16)
  # Requires:
  #   self.has_previousPage == true
  # Set:
  #   @currentPage to the previous page of current page
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
    unless self.current_pageNum == self.last_pageNum
      lastPage = self.last_pageNum
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
  # @return
  #   true if there is a next page, false otherwise
  def has_nextPage?
    @agent.page.links.find{|link| link.text == "Next »"} == nil ? false : true
  end

  # Created (Hongda Lin, 6/16)
  # @return
  #   true if there is a next page, false otherwise
  def has_previousPage?
    @agent.page.links.find{|link| link.text == "« Prev"} == nil ? false : true
  end

  # Created (Hongda Lin, 6/17)
  # trending news are the three news display on the middle, only need to scrape once, but need to keep update
  # @return
  #   the title of trending news in an Array, each title is represented as a string
  def trend_news_titles
    titles = @currentPage.xpath('//h2[@class="post-title"]/a')
    arr_titles = Array.new
    titles.each_with_index {|title,index| arr_titles<<title.text if index < 3}
    arr_titles
  end

  # Created (Hongda Lin, 6/17)
  # trending news are the three news display on the middle, only need to scrape once, but need to keep update
  # @return
  #   the links of trending news in an Array, each link is represented as a string
  def trend_news_links
    links = @currentPage.xpath('//h2[@class="post-title"]/a/@href')
    arr_links = Array.new
    links.each_with_index {|link,index| arr_links<<link.text if index < 3}
    arr_links
  end

  # Created (Hongda Lin, 6/17)
  # mask news are the news display on the top, only need to scrape once, but need to keep update
  # @return
  #   the title of mask news in an Array, each title is represented as a string
  def mask_news_titles
    titles = @currentPage.xpath('//a[@class="mask-title"]')
    arr_titles = Array.new
    titles.each {|title| arr_titles<<title.text}
    arr_titles
  end

  # Created (Hongda Lin, 6/17)
  # mask news are the news display on the top, only need to scrape once, but need to keep update
  # @return
  #    the links of mask news in an Array, each link is represented as a string
  def mask_news_links
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
  # @return
  #   the titles of news of current page in an Array, each title is represented as a string, not include the trend news and head news
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
  # @return
  #   the links of news of current page in an Array, each link is represented as a string, not include the trend news and head news
  #
  def reg_news_links
    links = @currentPage.xpath('//article[@class="post-summary post-format-standard clearfix"]//h2[@class="post-title"]/a/@href')
    arr_links = Array.new
    links.each{|link| arr_links << link.text}
    arr_links
  end

  # Created (Hongda Lin, 6/17)
  # Return last page number
  def last_pageNum
    arr_pageNumbers = @currentPage.xpath('//a[@class="page-numbers"]').to_a
    arr_pageNumbers[-1].text
  end

  # Created (Hongda Lin, 6/17)
  # Return current page number
  def current_pageNum
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



