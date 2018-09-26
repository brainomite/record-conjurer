require_relative 'assoc_options'

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] ||
                   "#{self_class_name.downcase}_id".to_sym
    @class_name = options[:class_name] || name.camelcase.singularize
    @primary_key = options[:primary_key] || :id
  end
end
