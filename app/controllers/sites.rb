class Sites < Application
  def create
    site = begin
      Site.create(params.permit(*Site.allows))
    rescue Mongo::Error::OperationFailure => e
      raise(e) unless /E11000 duplicate key/ === e.message

      Site.where(:url => params[:url]).first!
    end

    json site
  end
end
