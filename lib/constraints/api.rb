class Constraints::Api

  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(request)
    @default || request.headers['Accept']
                       .include?("application/vnd.coffeeshopph.v#{@version}")
  end

end
