require 'roda'
require 'graphql'
require 'pry'

require 'json'

require_relative './lib/post'
require_relative './lib/post_type'
require_relative './lib/query_type'
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
