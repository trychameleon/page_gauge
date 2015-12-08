class User < Model
  attrs String => { :uid => :d, :email => :e, :latest_url => :u }

  allow :uid, :email, :latest_url

  indexed :email, :uniq => true

  validates :email, :presence => true

  def email=(other)
    self[:email] = other.try(:downcase)
  end

end
