class FakeModel
  def self.find(ids)
    puts "finding: #{ids.inspect}"

    # Mimic DB latency
    # sleep((100 + ids.length) / 100_000.0)

    records = Array(ids).map { |id| { id: id.to_i, title: "Doesn't Matter #{id}" } }
    ids.is_a?(Array) ? records : records.first
  end
end

Post = Class.new FakeModel
Blog = Class.new FakeModel
