class GithubRepo
  attr_reader :name, :full_name

  def initialize(data)
    @name = data[:full_name]
    @contributors = data.map do |k, v|
      require "pry"; binding.pry
      k[:login]
    end
  end
end
