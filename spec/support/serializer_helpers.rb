module SerializerHelpers
  def serialize(record)
    JSON.parse(serialization(record).to_json)
  end

  def serialization(record)
    serializer = described_class.new(record)
    ActiveModelSerializers::Adapter.create(serializer)
  end
end

RSpec.configure do |config|
  config.include SerializerHelpers, type: :serializer
end
