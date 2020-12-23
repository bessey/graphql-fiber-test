class BaseField < GraphQL::Schema::Field
  # Add FiberResolveExtension to all fields. Probably a better way to do this...
  def initialize(*args, extensions: [], **kwargs, &block)
    super(*args, extensions: extensions.concat([FiberResolveExtension]), **kwargs, &block)
  end
end
class BaseObject < GraphQL::Schema::Object
  field_class BaseField
end

class PostType < BaseObject
  description 'A blog post'
  field :id, ID, null: false
  field :title, String, null: false
  field :reply, PostType, null: false

  def reply
    context.loader.find(Post, object[:id] + 100)
  end
end
class BlogType < BaseObject
  description 'A blog'
  field :id, ID, null: false
  field :title, String, null: false
  field :posts, [PostType], null: false

  def posts
    100.times.map { |i| { id: i, title: "My blog post #{i}" } }
  end
end
class QueryType < BaseObject
  description 'The query root of this schema'

  field :post, PostType, null: true do
    description 'Find a post by ID'
    argument :id, ID, required: true
  end

  field :post_fiber, PostType, null: true do
    description 'Find a post by ID'
    argument :id, ID, required: true
  end

  field :blog, BlogType, null: true do
    description 'Find a blog by ID'
    argument :id, ID, required: true
  end

  def post(id:)
    Post.find(id)
  end

  def post_fiber(id:)
    context.loader.find(Post, id)
  end

  def blog(id:)
    context.loader.find(Blog, id)
  end
end

class Schema < GraphQL::Schema
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  query QueryType

  context_class CustomContext

  lazy_resolve(LazyFiber, :value)
end
