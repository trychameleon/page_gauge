class Sites < Application
  def create
    json Site.where(:url => params[:url].downcase).
      first_or_create(params.permit(*Site.allows))
  end
end
