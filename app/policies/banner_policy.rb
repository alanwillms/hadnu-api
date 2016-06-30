class BannerPolicy < Struct.new(:user, :record)
  def show?
    true
  end
end
