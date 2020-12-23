class Schema < GraphQL::Schema
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST

  query QueryType

  context_class CustomContext
end
