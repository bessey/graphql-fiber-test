require 'webrick'
require_relative './example_app'

LazyFiber.enabled = true

run ExampleApp.freeze.app
