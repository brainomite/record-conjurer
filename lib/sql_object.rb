require_relative 'db_connection'
require_relative 'searchable'
require_relative 'associatable'
require 'active_support/inflector'

class SQLObject
  extend Searchable
  extend Associatable
  def initialize(params = {})
    params.each do |attr_name, value|
      attr_sym = attr_name.to_sym
      unless self.class.columns.include?(attr_sym)
        raise "unknown attribute '#{attr_name}'"
      end
      send("#{attr_name}=", value)
    end
  end

  def self.columns
    @columns_names ||= gen_column_names
  end

  def self.finalize!
    columns.each do |name|
      create_setter_and_getter(name)
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || to_s.tableize
  end

  def self.all
    datum = DBConnection.execute(<<-SQL)
    SELECT
      *
    from
      #{table_name}
    SQL
    parse_all(datum)
  end

  def self.parse_all(results)
    results.map { |row_hash| new(row_hash) }
  end

  def self.find(id)
    datum = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    from
      #{table_name}
    WHERE
      id = ?
    SQL
    parsed_data = parse_all(datum)
    parsed_data.first
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map { |attr| attributes[attr] }
  end

  def insert
    col_names = gen_insert_col_names
    question_marks = gen_insert_question_marks

    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks})
    SQL

    set_id_to_last
  end

  def update
    set_vals = gen_update_set

    DBConnection.execute(<<-SQL, *attribute_values, id)
    UPDATE
    #{self.class.table_name}
    SET
     #{set_vals}
    WHERE
      id = ?
    SQL
    set_id_to_last
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end

  # helper class methods

  def self.gen_column_names
    results = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    limit 1
    SQL

    first_result = results.first
    first_result.map(&:to_sym)
  end

  def self.create_setter_and_getter(name)
    create_getter(name)
    create_setter(name)
  end

  def self.create_getter(name)
    define_method(name) do
      attributes[name]
    end
  end

  def self.create_setter(name)
    define_method("#{name}=") do |val|
      attributes[name] = val
    end
  end

  private

  def set_id_to_last
    attributes[:id] = DBConnection.last_insert_row_id
  end

  def gen_insert_col_names
    columns_array = self.class.columns
    columns_array.join(', ')
  end

  def gen_insert_question_marks
    columns_array = self.class.columns
    question_array = Array.new(columns_array.length, '?')
    question_array.join(', ')
  end

  def gen_update_set
    columns = self.class.columns
    column_equals_array = columns.map { |attr_name| "#{attr_name} = ?" }
    column_equals_array.join(', ')
  end
end
