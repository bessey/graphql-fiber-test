class FiberResolveExtension < GraphQL::Schema::FieldExtension
  def resolve(object:, arguments:, **rest)
    LazyFiber.build { yield(object, arguments) }
  end
end
