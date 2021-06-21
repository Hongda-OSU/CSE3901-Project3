# created by: Hongda Lin (Date: 6/20/2021)
# Spec to test the Page class
require '../Page'
require 'rspec'
require 'mechanize'
require 'nokogiri'

describe Page do
  First_page = "https://www.thelantern.com/campus/"

  describe "goto_page (direction)" do
    context "string direction == #{"Next »"}" do
      it "should navigate to the next page" do
        page = Page.new
        expect(page.goto_page "Next »".current_page_num ).to eq 2
      end
    end
  end

end