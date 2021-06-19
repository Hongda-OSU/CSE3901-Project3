require 'mechanize'
require 'nokogiri'

# created by: Hongda Lin (Date: 6/16/2021)
class Page
  attr_reader :agent, :current_page
  @@URL = "https://www.thelantern.com/campus/"
  def initialize
    @agent = Mechanize.new
    @currentPage = @agent.get @@URL
  end

  # TODO merge these two?
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

  # TODO instead of moving forward, directly get the link (/page/number)
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

  # TODO merge these two?
  # TODO trim greatly
  # Created (Hongda Lin, 6/16)
  # @return
  #   true if there is a next page, false otherwise
  def has_nextPage?
    @agent.page.links.find{|link| link.text == "Next »"} == nil ? false : true
  end

  # TODO trim greatly
  # Created (Hongda Lin, 6/16)
  # @return
  #   true if there is a next page, false otherwise
  def has_previousPage?
    @agent.page.links.find{|link| link.text == "« Prev"} == nil ? false : true
  end

  # TODO merge titles and links into a hash or something
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

  # TODO merge titles and links into a hash or something
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

  # TODO merge titles and links into a hash or something
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

  # TODO trim greatly
  # Created (Hongda Lin, 6/17)
  # Return last page number
  def last_pageNum
    arr_pageNumbers = @currentPage.xpath('//a[@class="page-numbers"]').to_a
    arr_pageNumbers[-1].text
  end

  # TODO trim greatly
  # Created (Hongda Lin, 6/17)
  # Return current page number
  def current_pageNum
    current_pageNumber = @currentPage.xpath('//span[@class="page-numbers current"]')
    current_pageNumber.text
  end

  # TODO trim greatly
  # Created (Hongda Lin, 6/17)
  # Return true if current page is last page, false otherwise
  def is_lastPage?
    self.has_nextPage? ? false:true
  end

  # TODO trim greatly
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
