# Created by Madison Graziani on 6/22/2021
# Spec to test the Scraper class
require '../Scraper'
require 'rspec/autorun'

describe Scraper do

  # Created by Madison Graziani on 6/22/2021
  # @test
  #   scrape_body
  it "should return true" do
    scraper = Scraper.new
    scraper.scrape_reg_news
    symbol = "Ohio State research review suggests strong connection between narcissism and aggression".to_sym
    scraper.connect_page(scraper.reg_news[symbol])
    content = scraper.scrape_body
    expect(content.length > 0).to eq true
  end

  # Created by Madison Graziani on 6/22/2021
  # @test
  #   scrape_date
  it "should return true" do
    scraper = Scraper.new
    scraper.scrape_reg_news
    symbol = "Ohio State research review suggests strong connection between narcissism and aggression".to_sym
    scraper.connect_page(scraper.reg_news[symbol])
    date = scraper.scrape_date
    expect(date == "June 16, 2021").to eq true
  end

  # Created by Madison Graziani on 6/22/2021
  # @test
  #   scrape_author
  it "should return true" do
    scraper = Scraper.new
    scraper.scrape_reg_news
    symbol = "Ohio State research review suggests strong connection between narcissism and aggression".to_sym
    scraper.connect_page(scraper.reg_news[symbol])
    name = scraper.scrape_author
    expect(name == "Jessica Langer").to eq true
  end


  # Created by Madison Graziani on 6/22/2021
  # @test
  #   get_link and connect_page
  it "should return true" do
    scraper = Scraper.new
    scraper.scrape_reg_news
    title = "Ohio State research review suggests strong connection between narcissism and aggression"
    link = scraper.get_link 3, title
    scraper.connect_page(link)
    expect(scraper.news_page != nil).to eq true
  end

  # Created by Madison Graziani on 6/22/2021
  # @test
  #   get_title
  it "should return true" do
    scraper = Scraper.new
    scraper.scrape_reg_news
    title = scraper.get_title 3, 1
    link = scraper.get_link 3, title
    scraper.connect_page(link)
    expect(scraper.news_page != nil).to eq true
  end

  # Created by Hongda Lin on 6/22/2021
  # @test
  #   scrape_mask_news
  it "should Set @mask_news to a hash" do
    scraper = Scraper.new
    scraper.scrape_mask_news
    expect(scraper.mask_news.instance_of? Hash).to eq true
  end

  # Created by Hongda Lin on 6/22/2021
  # @test
  #   scrape_trend_news
  it "should Set @trend_news to a hash" do
    scraper = Scraper.new
    scraper.scrape_trend_news
    expect(scraper.trend_news.instance_of? Hash).to eq true
  end

  # Created by Hongda Lin on 6/22/2021
  # @test
  #   scrape_reg_news
  it "should Set @reg_news to a hash" do
    scraper = Scraper.new
    scraper.scrape_reg_news
    expect(scraper.reg_news.instance_of? Hash).to eq true
  end

  # Created by Hongda Lin on 6/22/2021
  # @test
  #   create_regexp
  it "should create a Regular expression with the terms provide" do
    scraper = Scraper.new
    expect(scraper.create_regexp "He").to eq /He/
  end

end