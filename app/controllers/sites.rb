class Sites < Application
  def create
    url = params[:url]
    url = "http://#{url}" unless /https?:\/\// === url

    json Site.where(:url => url).first ||
      Site.create(params.permit(*Site.allows))
  end
end
