module SerializerHelpers
  def serialize(record)
    JSON.parse(serialization(record).to_json)
  end

  def serializer_to_hash(serializer)
    JSON.parse(
        ActiveModelSerializers::Adapter.create(serializer).to_json
    )
  end

  def serialization(record)
    serializer = described_class.new(
      record,
      scope: build(:user), scope_name: :current_user
    )
    ActiveModelSerializers::Adapter.create(serializer)
  end
end

RSpec.configure do |config|
  config.include SerializerHelpers, type: :serializer
end
