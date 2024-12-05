require 'sequel'
require_relative 'product'

class Job < Sequel::Model
  def perform
    sleep(5)
    product = Product.create(JSON.parse(payload))
    if product.nil?
      update(state: 'error', result: { message: 'Create product failed' }.to_json)
    else
      update(state: 'success', result: { product: }.to_json)
    end
  rescue StandardError => e
    update(state: 'error', result: { message: e.message }.to_json)
  end
end
