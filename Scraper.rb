# created by: Hongda Lin (Date: 6/16/2021)

require 'mechanize'
require 'nokogiri'

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

  # Created (Hongda Lin, 6/16)
  # Return true if there is a next page, false otherwise
  def has_nextPage
    @agent.page.links.find{|link| link.text == "Next »"} == nil ? false : true
  end

  # Created (Hongda Lin, 6/16)
  # Return true if there is a next page, false otherwise
  def has_previousPage
    @agent.page.links.find{|link| link.text == "« Prev"} == nil ? false : true
  end

  # Created (Hongda Lin, 6/16)
  #
  # titles has class:  Nokogiri::XML::NodeSet
  # each title inside titles has class: Nokogiri::XML::Element
  #
  # Return an array of strings (title)
  #
  # Problem: for each page the first three title are always the same
  def currentPage_newsTitles
    titles = @currentPage.xpath('//h2[@class="post-title"]/a')
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
    links = @currentPage.xpath('//h2[@class="post-title"]/a/@href')
    arr_links = Array.new
    links.each{|link| arr_links << link.text}
    arr_links
  end


end

#Test
page = Page.new
page.goto_nextPage
#puts page.has_previousPage
#puts page.has_nextPage
page.currentPage_newsLinks



