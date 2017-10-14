# frozen_string_literal: true

ErrorType = GraphQL::ObjectType.define do
  name 'Error'
  description 'A validation error'
  field :attribute, !types.String, 'Attribute name'
  field :message, !types.String, 'Error message'
end
