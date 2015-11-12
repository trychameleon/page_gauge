class User < Model
  attrs String => { :email => :e }

  allow :email

  indexed :email, :uniq => true

  validates :email, :presence => true

  def email=(other)
    self[:email] = other.try(:downcase)
  end

end
