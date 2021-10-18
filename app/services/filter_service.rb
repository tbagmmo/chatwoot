require 'json'

class FilterService

  def initialize(params, user)
    @params = params
    @user = user
    file = File.read('./lib/filters/filter_keys.json')
    @filters = JSON.parse(file)
    @query_string = ''
    @filter_values = {}
  end

  def perform
  end

  def filter_operation(query_hash, current_index)
    case query_hash[:filter_operator]
    when 'equal_to'
      @filter_values["value_#{current_index}"] = query_hash[:values]
      "IN (:value_#{current_index})"
    when 'not_equal_to'
      @filter_values["value_#{current_index}"] = query_hash[:values]
      "NOT IN (:value_#{current_index})"
    when 'contains'
      @filter_values["value_#{current_index}"] = "%#{query_hash[:values]}%"
      "LIKE :value_#{current_index}"
    when 'does_not_contain'
      @filter_values["value_#{current_index}"] = "%#{query_hash[:values]}%"
      "NOT LIKE :value_#{current_index}"
    else
      @filter_values["value_#{current_index}"] = "#{query_hash[:values]}"
      "= :value_#{current_index}"
    end
  end
end
