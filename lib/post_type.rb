class PostType < GraphQL::Schema::Object
  description 'A blog post'
  field :id, ID, null: false
  field :title, String, null: false
  field :reply, PostType, null: false

  def reply
    context.loader.find(Post, object[:id] + 100)
  end
end
