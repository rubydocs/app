import "@hotwired/turbo-rails"
import "popper"
import "bootstrap"

import { Application }              from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()

application.debug = false
window.Stimulus   = application

eagerLoadControllersFrom("controllers", application)
