class FiberResolveExtension < GraphQL::Schema::FieldExtension
  def resolve(object:, arguments:, **rest)
    if LazyFiber.enabled?
      LazyFiber.build { yield(object, arguments) }
    else
      yield(object, arguments)
    end
  end
end
