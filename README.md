# CoffeeShop-Web #

This is a coffee shop application developed using Ruby on Rails.

### Summary ###

* Version: 1.0.0
* Authors:
    * Gino Mempin ([gino.mempin@gmail.com](gino.mempin@gmail.com))
    * Jonalyn Valencia ([jonalyn.valencia@gmail.com](jonalyn.valencia@gmail.com))

### Dependencies ###

* Ruby on Rails (http://guides.rubyonrails.org/getting_started.html)

### Setup and Installation ###

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

### Changelog ###

* 1.0.0 - initial version
