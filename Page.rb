require 'mechanize'
require 'nokogiri'

# created by: Hongda Lin (Date: 6/16/2021)
# update: change @currentPage to @current_page (Hongda 6/19)
class Page
  attr_reader :agent, :current_page
  @@URL = "https://www.thelantern.com/campus/"
  def initialize
    @agent = Mechanize.new
    @current_page = @agent.get @@URL
  end

  # Created (Hongda Lin, 6/16)
  # update: change method name to goto_next_page (Hongda 6/19)
  # update: change method name to goto_previous_page (Hongda 6/19)
  # Edited 6/19/21 by Samuel Gernstetter
  #   merge goto_next_page and goto_previous_page into goto_page
  #
  # @param direction (class String)
  #
  # Requires:
  #   (direction == "Next »" and self.has_next_page == true) or (direction == "« Prev" and self.has_previous_page == true)
  # Set:
  #   @current_page to the next or previous page of current page
  def goto_page direction
    page_link = @agent.page.links.find{|link| link.text == direction}
    page_link.resolved_uri
    @current_page = page_link.click
  end

  # Created (Hongda Lin, 6/16)
  # update: change method name to goto_next_page (Hongda 6/19)
  #
  # Requires:
  #   self.has_next_page == true
  # Set:
  #   @current_page to the next page of current page
  def goto_next_page
    next_page_link = @agent.page.links.find{|link| link.text == "Next »"}
    next_page_link.resolved_uri
    @current_page = next_page_link.click
  end

  # Created (Hongda Lin, 6/16)
  # update: change method name to goto_previous_page (Hongda 6/19)
  #
  # Requires:
  #   self.has_previous_page == true
  # Set:
  #   @current_page to the previous page of current page
  def goto_previous_page
    previous_page_link = @agent.page.links.find{|link| link.text == "« Prev"}
    previous_page_link.resolved_uri
    @current_page = previous_page_link.click
  end

  # Created (Hongda Lin, 6/17)
  # update: change method name to goto_first_page (Hongda 6/19)
  #
  # Page navigate to the first page
  def goto_first_page
    @current_page = agent.get @@URL
  end

  # Created (Hongda Lin, 6/17)
  # update: change method name to goto_last_page (Hongda 6/19)
  #
  # Page navigate to the last page
  def goto_last_page
    # check if current page is already last page
    unless self.current_page_num == self.last_page_num
      lastPage_page_link = @agent.page.links.find{|link| link.text == self.last_page_num}
      lastPage_page_link.resolved_uri
      @current_page = lastPage_page_link.click
    end
  end

  # Created (Hongda Lin, 6/17)
  # update: change method name to goto_particular_page and the new version is much quicker (Hongda 6/19)
  #
  # @param page_number (class Integer)
  #
  # Requires:
  #   self.has_particular_page? == true
  # Set:
  #   @current_page to the page number provide by the user
  # Page navigate to the page whose number is provide as a integer
  def goto_particular_page page_num
    @current_page = agent.get @@URL.concat "/","page","/",page_num.to_s,"/"
  end

  # Created (Hongda Lin, 6/16)
  # update: change method name to has_next_page?, cannot trim because it checks nil (Hongda 6/19)
  # Edited 6/19/21 by Samuel Gernstetter
  #
  # @return (class TrueClass)
  #   true if there is a next page, false otherwise
  def has_next_page?
     @agent.page.links.find{|link| link.text == "Next »"} != nil
  end

  # Created (Hongda Lin, 6/16)
  # update: change method name to has_previous_page?, cannot trim because it checks nil (Hongda 6/19)
  # Edited 6/19/21 by Samuel Gernstetter
  #
  # @return (class TrueClass)
  #   true if there is a next page, false otherwise
  def has_previous_page?
     @agent.page.links.find{|link| link.text == "« Prev"} != nil
  end

  # Created 6/20/21 by Samuel Gernstetter
  # Edit: fix bugs (Hongda 6/21/21 )
  #
  # @param page_num (class Integer)
  #
  # @return (class TrueClass)
  #   true if a page with the given number exists, false otherwise
  def has_particular_page? page_num
    page_num >= 1 && page_num <= self.last_page_num.to_i
  end

  # Created (Hongda Lin, 6/17)
  # trending news are the three news display on the middle, only need to scrape once, but need to keep update
  # Edited 6/20/21 by Samuel Gernstetter
  #   merge trend_news_titles and trend_news_links into trend_news, use a hash
  #
  # @return (class Hash)
  #   the titles=>links of trending news in a Hash, each title/link is represented as a string
  def trend_news
    trend = Hash.new
    titles = @current_page.xpath('//h2[@class="post-title"]/a')
    links = @current_page.xpath('//h2[@class="post-title"]/a/@href')
    titles.each_with_index { |title, index| trend[title.text.to_sym] = links[index].text if index < 3}
    trend
  end

  # Created (Hongda Lin, 6/17)
  # Edited 6/20/21 by Samuel Gernstetter
  #   merge mask_news_titles and mask_news_links into mask_news, use a hash
  # mask news are the news display on the top, only need to scrape once, but need to keep update
  #
  # @return (class Hash)
  #   the titles=>links of mask news in a Hash, each title/link is represented as a string
  def mask_news
    mask = Hash.new
    titles = @current_page.xpath('//a[@class="mask-title"]')
    links = @current_page.xpath('//a[@class="mask-title"]/@href')
    titles.each_with_index { |title, index| mask[title.text.to_sym] = links[index].text}
    mask
  end

  # Created (Hongda Lin, 6/17)
  # Edited 6/20/21 by Samuel Gernstetter
  #   merge reg_news_titles and reg_news_links into reg_news, use a hash
  # reg news is the grid at the bottom, only need to scrape once, but need to keep update
  #
  # @return (class Hash)
  #   the titles=>links of reg news in a Hash, each title/link is represented as a string
  def reg_news
    reg = Hash.new
    titles = @current_page.xpath('//article[@class="post-summary post-format-standard clearfix"]//h2[@class="post-title"]/a')
    links = @current_page.xpath('//article[@class="post-summary post-format-standard clearfix"]//h2[@class="post-title"]/a/@href')
    titles.each_with_index { |title, index| reg[title.text.to_sym] = links[index].text}
    reg
  end

  # Created (Hongda Lin, 6/17)
  # update: change method name to last_page_num (Hongda 6/19)
  #
  # @return (class String)
  #   Return last page number
  def last_page_num
    @current_page.xpath('//a[@class="page-numbers"]').to_a[-1].text
  end

  # Created (Hongda Lin, 6/17)
  # update: change method name to current_page_num (Hongda 6/19)
  #
  # @return (class String)
  #   Return current page number
  def current_page_num
    @current_page.xpath('//span[@class="page-numbers current"]').text
  end

  # Created (Hongda Lin, 6/17)
  # update: change method name to is_last_page? (Hongda 6/19)
  #
  # @return (class TrueClass)
  #   Return true if current page is last page, false otherwise
  def is_last_page?
    !self.has_next_page?
  end

  # Created (Hongda Lin, 6/17)
  # update: change method name to is_first_page? (Hongda 6/19)
  #
  # @return (class TrueClass)
  #   Return true if current page is first page, false otherwise
  def is_first_page?
    !self.has_previous_page?
  end

  # Created (Hongda Lin, 6/17)
  # Return the current page reg news hash, for debugging
  def info
    self.reg_news.keys
  end
end

