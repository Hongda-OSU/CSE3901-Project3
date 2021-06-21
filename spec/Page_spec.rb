# created by: Hongda Lin (Date: 6/20/2021)
# Spec to test the Page class
require '../Page'
require 'rspec/autorun'

describe Page do

  describe 'string direction == #{"Next »"} should navigate to the next page' do
      it "current page number should be #{"2"}" do
        page = Page.new
        page.goto_page"Next »"
        expect(page.current_page_num).to eq 2.to_s
      end
  end
  
end