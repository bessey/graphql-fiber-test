class Post
  def self.find(ids)
    puts "finding: #{ids.inspect}"
    posts =
      Array(ids).map { |id| { id: id.to_i, title: "Doesn't Matter #{id}" } }
    ids.is_a?(Array) ? posts : posts.first
  end
end
