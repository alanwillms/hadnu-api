require 'rails_helper'

describe PgSearch::DocumentPolicy do
  let(:normal_user) { create(:user) }
  let(:admin_user) { create(:admin_user) }
  let(:policy) { described_class }
  let(:pg_search_document) { create(:pg_search_document) }
  let(:published_section) { create(:section) }
  let(:blocked_section) { create(:blocked_section) }
  let(:unpublished_section) { create(:unpublished_section) }
  let(:signed_reader_only_section) { create(:signed_reader_only_section) }

  permissions :index? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).to permit(nil, PgSearch::Document)
      expect(policy).to permit(normal_user, PgSearch::Document)
      expect(policy).to permit(admin_user, PgSearch::Document)
    end
  end

  permissions :show?, :new?, :create?, :edit?, :update?, :destroy? do
    it 'allow access to guest, normal user and admin user' do
      expect(policy).not_to permit(nil, pg_search_document)
      expect(policy).not_to permit(normal_user, pg_search_document)
      expect(policy).not_to permit(admin_user, pg_search_document)
    end
  end

  describe '.scope' do
    before(:each) do
      published_section
      blocked_section
      unpublished_section
      signed_reader_only_section
    end

    it 'lists all to admin user' do
      expect(Pundit.policy_scope(admin_user, PgSearch::Document).count).to eq(4)
    end

    it 'lists only unblocked & published + signed reader only sections to normal user' do
      scoped = Pundit.policy_scope(normal_user, PgSearch::Document)
      expect(scoped.count).to eq(2)
      expect(scoped.first.searchable).to eq(published_section)
      expect(scoped.last.searchable).to eq(signed_reader_only_section)
    end

    it 'lists only unblocked & published sections to normal user' do
      scoped = Pundit.policy_scope(nil, PgSearch::Document)
      expect(scoped.count).to eq(1)
      expect(scoped.first.searchable).to eq(published_section)
    end
  end
end
