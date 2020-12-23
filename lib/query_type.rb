class QueryType < GraphQL::Schema::Object
  description 'The query root of this schema'

  field :post, PostType, null: true do
    description 'Find a post by ID'
    argument :id, ID, required: true
  end

  field :post_fiber, PostType, null: true do
    description 'Find a post by ID'
    argument :id, ID, required: true
  end

  def post(id:)
    Post.find(id)
  end

  def post_fiber(id:)
    context.loader.find(Post, id)
  end
end
