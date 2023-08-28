# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

#### Stimulus Installation
Add stimulus to your Gemfile:
`gem 'stimulus-rails'`

And after that run:
```
bin/rails stimulus:install
yarn add @hotwired/stimulus
yarn add @hotwired/stimulus-webpack-helpers
```

Now, we are going to need to add some configuration into app/javascript/application.js
```
import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()
const context = require.context("./controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))
```

In this case, we want to build our app/javascript/controllers/home_controller.js, it should look something like this:
```
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }
}
```

Finally, to load it, we need to add in app/javascript/controllers/index.js
```
import HomeController from './controllers/home_controller.js'
application.register('home', HomeController)
```
