module GraphqlHelpers
  def expect_fields_have_description(type)
    empty_fields = []
    type.fields.each do |id, field|
      empty_fields << id if field.description.nil?
    end
    expect(empty_fields).to eq([])
  end
end

RSpec.configure do |config|
  config.include GraphqlHelpers, type: :graphql
end
