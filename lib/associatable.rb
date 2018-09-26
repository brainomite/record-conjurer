require_relative 'belongs_to_options'
require_relative 'has_many_options'

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name.to_s, options)
    assoc_options[name.to_sym] = options
    define_method(name) do
      val = send(options.foreign_key)
      options.model_class.where(options.primary_key => val).first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name.to_s, self.name, options)
    define_method(name) do
      val = send(options.primary_key)
      options.model_class.where(options.foreign_key => val)
    end
  end

  def assoc_options
    @assoc_options_hash ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]

      through_table_name = through_options.table_name
      through_pri_key = through_options.primary_key
      through_for_key = through_options.foreign_key

      source_options = through_options.model_class
                                      .assoc_options[source_name]

      source_table_name = source_options.table_name
      source_for_key = source_options.foreign_key

      key = send(through_for_key)
      results = DBConnection.execute(<<-SQL, key)
        SELECT
          #{source_table_name}.*
        FROM
          #{source_table_name}
        JOIN
          #{through_table_name}
        ON
          #{source_table_name}.#{through_pri_key} =
          #{through_table_name}.#{source_for_key}
        WHERE
          #{through_table_name}.#{through_pri_key} = ?
      SQL
      source_options.model_class.parse_all(results).first
    end
  end
end
