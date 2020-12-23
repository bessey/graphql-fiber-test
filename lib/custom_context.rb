class CustomContext < GraphQL::Query::Context
  def loader
    self[:loader] ||= build_data_loader
  end

  private

  def build_data_loader
    LoaderManager.new
  end
end
