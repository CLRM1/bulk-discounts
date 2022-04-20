class GithubRepo
  attr_reader :name, :full_name

  def initialize(data)
    @name = data[:full_name]
  end
end
