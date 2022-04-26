class Holiday
  attr_reader :date_1, :date_2, :date_3, :name_1, :name_2, :name_3

  def initialize(data)
    @date_1 = data[0][:date]
    @date_2 = data[1][:date]
    @date_3 = data[2][:date]
    @name_1 = data[0][:name]
    @name_2 = data[1][:name]
    @name_3 = data[2][:name]
  end
end
