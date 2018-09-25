require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
      @columns_names ||= DBConnection.execute2(<<-SQL)
      SELECT
      *
      FROM
      #{table_name}
      limit 1
      SQL
        .first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |name|
      define_method(name) do
        attributes[name]
      end
      define_method("#{name}=") do |val|
        attributes[name] = val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
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
    results.map { |row_hash| self.new(row_hash) }
  end

  def self.find(id)
    datum = DBConnection.execute(<<-SQL, id)
    SELECT
    *
    from
    #{table_name}
    WHERE id = ?
    SQL
    parse_all(datum).first
  end

  def initialize(params = {})
      params.each do |attr_name, value|
        attr_sym = attr_name.to_sym
        unless self.class.columns.include?(attr_sym)
          raise "unknown attribute '#{attr_name}'"
        end
        send("#{attr_name}=", value)
      end
  end

  def attributes
    @attributes ||= {}

  end

  def attribute_values
    self.class.columns.map { |attr| attributes[attr]  }
  end

  def insert
    col_names = self.class.columns.join(', ')
    question_marks = Array.new(self.class.columns.length, '?').join(', ')
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
    #{self.class.table_name} (#{col_names})
    VALUES
      (#{question_marks})
    SQL
    attributes[:id]=DBConnection.last_insert_row_id
  end

  def update
    col_vals = self.class.columns
      .map { |attr_name| "#{attr_name} = ?" }
      .join(', ')
    DBConnection.execute(<<-SQL, *attribute_values, id)
    UPDATE
    #{self.class.table_name}
    SET
     #{col_vals}
    WHERE
      id = ?
    SQL
    attributes[:id]=DBConnection.last_insert_row_id
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end

end
