require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where = params.keys.map { |val| "#{val} = ?" }
      .join(' AND ')
    values = params.keys.map { |key| params[key] }
    datum = DBConnection.execute(<<-SQL, *values)
    SELECT
      *
    FROM
      #{table_name}
    WHERE
      #{where}
    SQL
    parse_all(datum)
  end
end

class SQLObject
  extend Searchable
end
