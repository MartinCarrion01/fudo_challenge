require 'sequel'
require_relative 'job'

class Product < Sequel::Model
  plugin :validation_helpers

  def validate
    validates_presence [:name]
    validates_length_range 3..100, :name
  end

  def create_async
    job = Job.create(payload: { name: }.to_json)
    return if job.nil?

    Thread.new { job.perform }
    job.id
  end
end
