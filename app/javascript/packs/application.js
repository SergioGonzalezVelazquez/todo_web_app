// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


// JS libraries
import "jquery"
import "jquery-ujs"
import "bootstrap"

// require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

//jQuery
//require('jquery')
//require('jquery-ujs')

//Bootstrap
//require('bootstrap')


//Font Awesome 5
require('@fortawesome/fontawesome-free/css/all.css')

//Custom scripts for all pages
require("sb-admin-2/sb-admin-2.min")
require("sb-admin-2/sb-admin-2")

//require("sb-admin-2/demo/chart-area-demo")
//require("sb-admin-2/demo/chart-bar-demo")
//require("sb-admin-2/demo/chart-pie-demo")
//require("sb-admin-2/demo/datatables-demo")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)