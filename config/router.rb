require_relative 'route'

class Router
  attr_reader :routes

  def initialize
    @routes = Hash.new { |hash, key| hash[key] = [] }
  end

  def route(path, method)
    routes[method].each do |registered_route|
      route_regex = registered_route.first.gsub(/:(\w+)/, '(?<\1>[^/]+)')
      next unless path.match?(Regexp.new("^#{route_regex}$"))

      match = path.match(Regexp.new("^#{route_regex}$"))
      return Route.new(*registered_route, match.named_captures.transform_keys!(&:to_sym))
    end

    nil
  end

  def draw(&block)
    instance_eval(&block)
  end

  %i[get post put delete].each do |http_method|
    define_method(http_method) do |path, to:|
      routes[http_method] << [path, parse_to_route(to)]
    end
  end

  def parse_to_route(to)
    controller_path, action = to.split('#')
    { controller_path:, action: }
  end
end
