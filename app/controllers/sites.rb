class Sites < Application
  html :show

  def create
    url = params[:url]
    url = params[:url] = "http://#{url}" unless /https?:\/\// === url

    json Site.where(:url => url).earliest ||
      Site.create(params.permit(*Site.allows))
  end
end
