require 'dotenv'
require 'jwt'
require 'securerandom'
require_relative '../config/exception'

class JwtUtils
  SECRET_KEY = ENV.fetch('SECRET_KEY', '7ad2ebfc87a1c7756b2ea72c107c1001c65a420749f506e8ef38321057342f88')

  def self.encode(payload)
    payload[:exp] = Time.now.to_i + 86_400
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY).first
  rescue JWT::ExpiredSignature
    raise AuthenticationError, 'Token has expired'
  rescue JWT::DecodeError
    raise AuthenticationError, 'Invalid token'
  end
end
