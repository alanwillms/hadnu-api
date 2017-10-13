require 'rails_helper'

describe GraphqlController do
  describe '#create' do
    it 'executes GraphQL Schema' do
      expect(Schema).to receive(:execute).with('query { }', any_args)
      post :create, params: { query: 'query { }' }
    end
  end
end
