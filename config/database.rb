require 'dotenv'
require 'sequel'

class Database
  DATABASE_FILE_PATH = ENV.fetch('DATABASE_FILE_PATH', 'db/fudochallenge.sqlite3')

  def self.connect
    Sequel::Model.plugin :json_serializer
    @connect ||= Sequel.sqlite(DATABASE_FILE_PATH)
  end
end
