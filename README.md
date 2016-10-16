# CoffeeShopPH-Web #

This is a Ruby on Rails web app for managing the operations of a café or a restaurant.

### Environment ###

* Mac OS X 10.10.5 (Yosemite)
* Homebrew 0.9.5
* Ruby 2.2.4
* RVM 1.26.11
* Rails 4.2.2
* Heroku Toolbelt 3.42.25
* Heroku CLI 5.2.24

### Setup ###

* [HOW-TO setup Ruby and Rails](http://guides.rubyonrails.org/getting_started.html)
* HOW-TO run the application in Heroku
    * Create an account in Heroku
    * Install the Heroku Toolbelt
    * Switch to the production branch (i.e. master)
    * In your local copy of the project:
        * ```heroku login```
        * ```heroku keys:add```
    * Prepare the heroku remote
        * If the heroku app already exists: ```git remote add heroku <git-URL-of-app>```
        * If creating the app for the first time: ```heroku create <app-name>```
    * Verify that the heroku remote was created:
        * ```git remote -v```
    * Push production code to heroku: ```git push heroku master```
    * Access the page using its https://app-name.herokuapp.com URL

### References ###

* [The Ruby on Rails Tutorial 3rd ed.](http://3rd-edition.railstutorial.org/) by Michael Hartl
* [APIs on Rails](http://apionrails.icalialabs.com/) by Abraham Kuri Vargas
