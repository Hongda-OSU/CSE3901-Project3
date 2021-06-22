# created by: Hongda Lin (Date: 6/20/2021)
# Spec to test the Page class
require '../Page'
require 'rspec/autorun'

describe Page do

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   current_page_num
    it "should return current page number #{"1"} " do
      page = Page.new
      expect(page.current_page_num).to eq "1"
    end

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   last_page_num
  describe 'it cannot be test since the website will update itself' do
    it "should return the last page number as String" do
      page = Page.new
      expect(page.last_page_num.instance_of? String).to eq true
    end
  end

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   is_last_page?
    it "should return false" do
      page = Page.new
      expect(page.is_last_page?).to eq false
    end

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   is_first_page?
  it "should return true " do
    page = Page.new
    expect(page.is_first_page?).to eq true
  end

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   has_next_page?
  it "should return true" do
    page = Page.new
    expect(page.has_next_page?).to eq true
  end

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   has_previous_page?
  it "should return false" do
    page = Page.new
    expect(page.has_previous_page?).to eq false
  end

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   has_particular_page?
  it "should return true if page_num is in range (1,last_page_num), false otherwise" do
    page = Page.new
    expect(page.has_particular_page? 15).to eq true
  end

  # created by: Hongda Lin (Date: 6/20/2021)
  # @test
  #   goto_page
      it "should set @current_page to the page next/previous to it}" do
        page1 = Page.new
        page1.goto_page"Next »"
        expect(page1.current_page_num).to eq "2"

        page2 = Page.new
        page2.goto_particular_page 16
        page2.goto_page "« Prev"
        expect(page2.current_page_num).to eq "15"
      end





end