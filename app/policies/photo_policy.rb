class PhotoPolicy < Struct.new(:user, :record)
  def show?
    true
  end
end
