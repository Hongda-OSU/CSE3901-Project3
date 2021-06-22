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
      expect(page.current_page_num).to eq 1
    end

  # created by: Hongda Lin (Date: 6/21/2021)
  # @test
  #   last_page_num
  describe 'it cannot be test since the website will update itself' do
    it "should return the last page number as String" do
      page = Page.new
      expect(page.last_page_num.instance_of? Integer).to eq true
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
    last_page_number = page.last_page_num
    range = Range.new 1, last_page_number
    expect(page.has_particular_page? 15).to eq range.include? 15
  end

  # created by: Hongda Lin (Date: 6/20/2021)
  # @test
  #   goto_page
      it "should set @current_page to the page next/previous to it}" do
        page1 = Page.new
        page1.goto_page"Next »"
        expect(page1.current_page_num).to eq 2

        page2 = Page.new
        page2.goto_particular_page 16
        page2.goto_page "« Prev"
        expect(page2.current_page_num).to eq 15
      end

  # created by: Hongda Lin (Date: 6/22/2021)
  # @test
  #   trend_news
  it "should return a hash with trending news titles as hash keys and trending news links as hash values" do
    page = Page.new
    test = {:"Ohio State, state of Ohio to lift states of emergency within two weeks"=>"https://www.thelantern.com/2021/06/ohio-state-state-of-ohio-to-lift-states-of-emergency-within-two-weeks/", :"14 hours ahead: COVID-19 presents unique challenges to international students"=>"https://www.thelantern.com/2021/06/14-hours-ahead-covid-19-presents-unique-challenges-to-international-students/", :"Ohio State renews contract with Wendy’s amidst ongoing student criticism"=>"https://www.thelantern.com/2021/06/ohio-state-renews-contract-with-wendys-amidst-ongoing-student-criticism/"}
    expect(page.trend_news).to eq test
  end

  # created by: Hongda Lin (Date: 6/22/2021)
  # @test
  #   mask_news
  it "should return a hash with mask news titles as hash keys and mask news links as hash values" do
    page = Page.new
    test = {:"Women sexually assaulted in off-campus area, suspect posed as rideshare driver"=>"https://www.thelantern.com/2021/06/women-sexually-assaulted-in-off-campus-area-suspect-posed-as-rideshare-driver/", :"Ohio State closed Friday to observe Juneteenth"=>"https://www.thelantern.com/2021/06/ohio-state-closed-friday-to-observe-juneteenth/"}
    expect(page.mask_news).to eq test
  end

  # created by: Hongda Lin (Date: 6/22/2021)
  # @test
  #   reg_news
  it "should return a hash with regular news titles as hash keys and regular news links as hash values" do
    page = Page.new
    test = {:"Ohio State research review suggests strong connection between narcissism and aggression"=>"https://www.thelantern.com/2021/06/ohio-state-research-review-suggests-strong-connection-between-narcissism-and-aggression/", :"Ohio Union now accepting space requests for fall semester"=>"https://www.thelantern.com/2021/06/ohio-union-now-accepting-space-requests-for-fall-semester/", :"Dean of College of Arts and Sciences Gretchen Ritter to leave Ohio State"=>"https://www.thelantern.com/2021/06/dean-of-college-of-arts-and-sciences-gretchen-ritter-to-leave-ohio-state/", :"Ohio State removes mask mandate and social distancing guidelines for vaccinated individuals"=>"https://www.thelantern.com/2021/06/ohio-state-removes-mask-mandate-and-social-distancing-guidelines-for-vaccinated-individuals/", :"Columbus Police officers charged for conduct during summer 2020 Black Lives Matter protests"=>"https://www.thelantern.com/2021/06/columbus-police-officers-charged-for-conduct-during-summer-2020-black-lives-matter-protests/", :"New task force aims to improve mental health culture on campus"=>"https://www.thelantern.com/2021/06/new-task-force-aims-to-improve-mental-health-culture-on-campus/", :"James L. Moore III earns American Council on Education Reginald Wilson Diversity in Leadership Award"=>"https://www.thelantern.com/2021/06/james-l-moore-iii-earns-american-council-on-education-reginald-wilson-diversity-in-leadership-award/", :"Mayor Andrew Ginther approves the repeal of the city’s mask mandate"=>"https://www.thelantern.com/2021/06/columbus-city-council-votes-to-repeal-mask-mandate-awaits-mayor-andrew-ginthers-final-approval/", :"Scammers target international students via phone"=>"https://www.thelantern.com/2021/06/scammers-target-international-students-via-phone/", :"Columbus Police looks to identify 19 more persons of interest in “Chitt Fest” riot"=>"https://www.thelantern.com/2021/06/columbus-police-looks-to-identify-19-more-persons-of-interest-in-chitt-fest-riot/", :"On-campus robbery Thursday night prompts safety notice"=>"https://www.thelantern.com/2021/06/on-campus-robbery-thursday-night-prompts-safety-notice/", :"Buckeyes Unsung: Behind the scenes with Ohio State professionals"=>"https://www.thelantern.com/2021/06/buckeyes-unsung/"}
    expect(page.reg_news).to eq test
  end



end