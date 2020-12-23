# Registration system for Loaders
class LoaderManager
  def initialize
    @store = LoaderStore.new
  end

  attr_reader :store

  def find(scope, id)
    loader = store.get(FindByIdLoader, [scope])
    run_loader(loader, id)
  end

  # You could have different loaders here

  private

  def run_loader(loader, key)
    loader.enqueue(key)

    # Where the magic happens, yield back to the interpreter so it may queue other IDs before we try and load data
    if LazyFiber.enabled?
      Fiber.yield
    else
      puts 'WARNING: Loader called without a Fiber in context, misconfigured?'
    end

    loader.find(key)
  end
end

# Per query store for instances of loaders
class LoaderStore
  def initialize
    @cache = {}
  end

  attr_reader :cache

  def get(loader, args)
    cache[args] ||= loader.new(*args)
  end
end

# Largely inspired by graphql-batch loaders API
class Loader
  def initialize(scope)
    @scope = scope
    @keys_to_results = {}
  end

  attr_reader :scope, :keys_to_results

  def enqueue(id)
    keys_to_results[id.to_i] = nil
  end

  def find(id)
    populate_results_if_missing
    keys_to_results[id.to_i]
  end

  private

  def populate_results_if_missing
    keys_missing_values = keys_to_results.select { |k, v| v.nil? }.map(&:first)
    return if keys_missing_values.empty?
    perform(keys_missing_values)
  end

  def perform(_keys)
    raise NotImplementedError
  end

  def fulfill(key, value)
    keys_to_results[key] = value
  end
end

# Trivial example loader
class FindByIdLoader < Loader
  def initialize(scope)
    super
    @scope = scope
  end

  attr_reader :scope

  private

  def perform(keys)
    scope.find(keys).each { |result| fulfill(result[:id], result) }
  end
end
