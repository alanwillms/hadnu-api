require 'json'
require 'ostruct'

class GraphqlHelper
  def self.create_mutation_result_type(item_type:, item_field:, item_description:, name:, description:)
    GraphQL::ObjectType.define do
      name name
      description description || nil
      field item_field, item_type, item_description || 'Mutation result'
      field :errors, types[ErrorType], 'List of error messages'
    end
  end

  def self.hash_to_struct(hash)
    JSON.parse(hash.to_json, object_class: OpenStruct)
  end
end
