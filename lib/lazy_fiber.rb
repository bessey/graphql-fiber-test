# Make a given block of code into a Fiber that quacks like a graphql-ruby lazy object.
# May return another lazy object (itself actually) until the Fiber has concluded.
class LazyFiber
  def self.enabled?
    @enabled
  end

  def self.enabled=(bool)
    @enabled = bool
  end

  def self.build(&block)
    new(block)
  end

  def initialize(block)
    @fiber = Fiber.new { block.call }
    @last_value = @fiber.resume
  end

  def value
    return @last_value unless @fiber.alive?
    @last_value = @fiber.resume
    self
  end
end
