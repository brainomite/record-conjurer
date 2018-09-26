require_relative 'db_connection'

module Searchable
  def where(params)
    where = gen_where_line(params)
    values = gen_values(params)

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

  private

  def gen_values(params)
    params.keys.map { |key| params[key] }
  end

  def gen_where_line(params)
    where_array = params.keys.map { |val| "#{val} = ?" }
    where_array.join(' AND ')
  end
end
