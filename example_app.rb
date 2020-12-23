require 'roda'
require 'graphql'
require 'pry'
require 'fiber'

require 'json'

require_relative './lib/lazy_fiber'
require_relative './lib/fiber_resolve_extension'
require_relative './lib/models'
require_relative './lib/custom_context'
require_relative './lib/schema'
require_relative './lib/loader'
class ExampleApp < Roda
  plugin :json
  plugin :json_parser

  route do |r|
    r.root { 'Hello World' }

    r.post { Schema.execute(r.params['query']).to_h }
  end
end
