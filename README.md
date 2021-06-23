# Project 3
### Web Scraping

### Roles
* Overall Project Manager: Madison Graziani
* Coding Manager: Sam Gernstetter
* Testing Manager: Hongda Lin
* Documentation: Drew Jackson

### Contributions
Please list who did what for each part of the project.
Also list if people worked together (pair programmed) on a particular section.

* Hongda Lin: 
  * wrote the Page class, assisted with Scraper class, wrote rspec for Page class methods
          
* Drew Jackson: 
  * WIP
            
* Madison Graziani: 
  * WIP
                   
* Samuel Gernstetter: 
  * wrote majority of View class, wrote main loop with Drew, assisted here and there with Page and Scraper

### Running the Web Scraper
  * To run the program, you can run Main.rb using an IDE such as RubyMine or run the command: ruby Main.rb.
  * For optimal reading, enable word wrap or an equivalent feature in whatever you're using to run this.
  * There are four options to choose from immediately after running the web scraper:
    * Entering 'continue' will print a list of article titles from the OSU's Lantern newspaper
    * Entering 'search' will allow you to search for articles by a specific keyword
    * Entering 'quit' will cause the program to exit
  * After entering 'continue':
    * A numbered list of articles will be printed, including top news, trending news, and regular news.
    * You can enter the corresponding number of an article to read it. This will print the title, date, author, and content of the article. Any input will then return you to the list of articles.
    * You can enter 'next' or 'previous' to go to the next or previous page of articles on the Lantern and display them.
    * You can enter 'page' to select a page of articles to view
    * You can enter 'search' or 'quit', which function the same as from the main menu.
  * After entering 'page':
    * You will be prompted to enter the number of a page of articles you would like to then be displayed.
  * After entering 'search':
    * You will be prompted to enter a term/keyword to search for among the articles.
    * The discovered articles, if there are any, will then be displayed. You can choose to view the contents of these articles just as before.

### Functionality
  * Search - can search the articles by keywords/terms
  * Page Choice - can go to a specific page of the Lantern to see all the articles of that page
  * Next/Previous - can navigate the pages of articles without choosing a specific page
  * Displaying Articles - can display an article's author(s), publication date, and contents

### Runing rspec files
  * Go to the folder spec using terminal
  * Run command ruby Page_spec.rb for testing Page class methods
