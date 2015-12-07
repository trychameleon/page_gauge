class User < Model
  attrs String => { :uid => :d, :email => :e, :url => :u, :score => :s }

  allow :uid, :email, :url, :score

  indexed :email, :uniq => true

  validates :email, :presence => true

  def email=(other)
    self[:email] = other.try(:downcase)
  end

end
