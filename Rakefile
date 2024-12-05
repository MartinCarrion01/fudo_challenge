require 'dotenv/load'
require 'sequel'
require_relative 'config/database'

namespace :db do
  desc 'Create FudoChallenge database'
  task :create do
    puts 'Creating database. Please wait.'
    db_file = 'db/fudochallenge.sqlite3'
    if File.exist?(db_file)
      puts "Database already exists. Look for #{db_file} file. Exiting..."
    else
      File.open(db_file, 'w') {}
      puts "Created database succesfully. Look for #{db_file}. Exiting..."
    end
  end

  desc 'Drop FudoChallenge database'
  task :drop do
    puts 'Creating database. Please wait.'
    db_file = 'db/fudochallenge.sqlite3'
    if File.exist?(db_file)
      File.open(db_file, 'r') { |file| File.delete(file) }
      puts 'Dropped database succesfully. Exiting...'
    else
      puts 'Database does not exist. Exiting...'
    end
  end

  desc 'Run migrations'
  task :migrate do
    puts 'Running migrations. Please wait.'
    Sequel.extension :migration
    db = Database.connect
    Sequel::Migrator.run(db, './db/migrations')
    puts 'Migrated database succesfully.'
  end

  desc 'Seed database'
  task :seed do
    puts 'Seeding database. Please wait.'
    db = Database.connect

    unless db[:users].where(username: 'fudochallenge').first
      db[:users].insert(username: 'fudochallenge', password: '12345678')
    end

    db[:products].insert(id: 1, name: 'lomito') unless db[:products].where(id: 1).first

    db[:products].insert(id: 2, name: 'burger') unless db[:products].where(id: 2).first

    puts 'Database seeding completed.'
  end
end
