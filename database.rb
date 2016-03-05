require 'sequel'

DB = Sequel.sqlite

DB.create_table :lists do
  primary_key :id
  varchar :name
end

DB.create_table :tasks do
  primary_key :id
  integer :list_id
  varchar :task
  bit :completed
end

class List < Sequel::Model
  plugin :validation_helpers

  one_to_many :tasks

  def validate
    super
    validates_presence [:name]
    validates_unique [:name]
  end
end

class Task < Sequel::Model
  plugin :validation_helpers
  many_to_one :list

  def validate
    validates_presence [:list_id, :task, :completed]
  end
end
