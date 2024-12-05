class Route
  attr_accessor :path, :controller_path, :action, :dynamic_params

  def initialize(path, options, dynamic_params = {})
    @path = path
    @controller_path = options[:controller_path]
    @action = options[:action]
    @dynamic_params = dynamic_params
    require_relative "../app/controllers/#{@controller_path}_controller"
  end

  def parse_controller_path
    "#{@controller_path.split('/').map { |str| str.split('_').map(&:capitalize) }.join('::')}Controller"
  end

  def call(env)
    Module.const_get(parse_controller_path).new(env.merge!(dynamic_params:)).invoke(action)
  end
end
