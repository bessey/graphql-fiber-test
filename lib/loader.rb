class LoaderManager
  def initialize
    @store = LoaderStore.new
  end

  attr_reader :store

  def find(scope, id)
    loader = store.get(scope)
    loader.enqueue(id)

    # Where the magic happens, yield back to the interpreter so it may queue other IDs before we try and load data
    Fiber.yield
    loader.find(id)
  end
end

class LoaderStore
  def initialize
    @cache = {}
  end

  attr_reader :cache

  def get(scope)
    cache[scope] ||= FindByIdLoader.new(scope)
  end
end

class FindByIdLoader
  def initialize(scope)
    @scope = scope
    @ids_to_results = {}
  end

  attr_reader :scope, :ids_to_results

  def enqueue(id)
    ids_to_results[id.to_i] = nil
  end

  def find(id)
    populate_results_if_missing
    ids_to_results[id.to_i]
  end

  private

  def populate_results_if_missing
    missing_values = ids_to_results.select { |k, v| v.nil? }.map(&:first)
    return if missing_values.empty?
    scope
      .find(missing_values)
      .map { |result| ids_to_results[result[:id]] = result }
  end
end
