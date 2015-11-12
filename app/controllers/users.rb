class Users < Application
  def create
    json User.where(:email => params[:email].downcase).
      first_or_create(params.permit(*User.allows))
  end
end
