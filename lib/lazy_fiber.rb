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
