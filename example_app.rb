require 'roda'
require 'graphql'
require 'json'

require_relative './lib/post'
require_relative './lib/post_type'
require_relative './lib/query_type'
require_relative './lib/schema'

class ExampleApp < Roda
  plugin :json
  plugin :json_parser

  route do |r|
    r.root { 'Hello World' }

    r.post { Schema.execute(r.params['query']).to_h }
  end
end
