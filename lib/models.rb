class FakeModel
  def self.find(ids)
    puts "finding: #{ids.inspect}"
    records = Array(ids).map { |id| { id: id.to_i, title: "Doesn't Matter #{id}" } }
    ids.is_a?(Array) ? records : records.first
  end
end

Post = Class.new FakeModel
Blog = Class.new FakeModel
