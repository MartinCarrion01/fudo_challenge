require_relative 'router'

module FudoChallenge
  class Application
    def self.router
      @router ||= Router.new
    end

    def call(env)
      route = FudoChallenge::Application.router.route(env['PATH_INFO'], env['REQUEST_METHOD'].downcase.to_sym)
      if route
        route.call(env)
      else
        [404, {}, ['Resource not found']]
      end
    end
  end
end
