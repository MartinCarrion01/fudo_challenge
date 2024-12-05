require 'rack'
require 'json'
require_relative '../models/user'
require_relative '../../config/exception'
require_relative '../../lib/jwt_utils'

class ApplicationController
  attr_accessor :request, :response, :params

  def initialize(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new({}, 200, { 'content-type' => 'application/json' })
    parsed_body = JSON.parse(request.body.read).transform_keys(&:to_sym) rescue {}
    @params = request.env[:dynamic_params].merge!(parsed_body)
  end

  def self.before_action(method, actions:)
    @before_actions ||= []
    @before_actions << { method:, actions: }
  end

  def self.before_actions
    @before_actions || []
  end

  def invoke(action)
    callbacks = self.class.before_actions
    callbacks.each do |callback|
      next unless callback[:actions].include?(action)

      result = send(callback[:method])
      return response.finish if result == false
    end

    send(action)
    response.finish
  rescue StandardError => e
    puts e
    render json: { message: 'Unexpected error' }, status: 500
    response.finish
  end

  protected

  def render(json:, status: 200, headers: {})
    response.body = [json.to_json]
    response.status = status
    response.headers.merge!(headers)
  end

  private

  def authenticate
    unless request.has_header?('HTTP_AUTHORIZATION')
      render json: { message: 'Authorization token missing' }, status: 401
      return false
    end

    token = request.get_header('HTTP_AUTHORIZATION')
    payload = JwtUtils.decode(token)
    @user = User.find(id: payload['user_id'])
    if @user.nil?
      render json: { message: 'User not found with given token' }, status: 401
      false
    end
  rescue AuthenticationError => e
    render json: { message: e.message }, status: 401
    false
  end
end
