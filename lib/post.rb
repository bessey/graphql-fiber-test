class Post
  def self.find(ids)
    posts = Array(ids).map { |id| { id: id, title: "Doesn't Matter #{id}" } }
    ids.is_a?(Array) ? posts : posts.first
  end
end
