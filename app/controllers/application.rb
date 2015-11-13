class Application < ActionController::Base
  def self.inherited(base)
    BasicObject.const_set("#{base.name}Controller", base)
  end

  def self.html(*names)
    names.each {|name| define_method name, -> {} }
  end

  before_action :enable_cors

  def options
    head :ok
  end

  def json(*models)
    status, json = :ok, {}
    status = :created if params[:action] == 'create'
    status = :unprocessable_entity if models.first.try(:invalid?)

    json.merge!(models.pop) if models.last.is_a?(Hash)

    models.each do |model|
      name = if model.is_a?(Array)
        model.compact!

        next unless model.any?
        model.first.class.name.underscore.pluralize
      else
        model.class.name.underscore
      end

      json[name] = model
    end

    render :json => json, :status => status
  end

  private

  def enable_cors
    response.headers.merge!(
      'Access-Control-Allow-Origin' => request.headers['Origin'].presence || '*',
      'Access-Control-Allow-Methods' => 'HEAD, GET, POST, PUT, PATCH, DELETE, OPTIONS',
      'Access-Control-Allow-Headers' => request.headers['Access-Control-Request-Headers'].presence || 'Origin, X-Requested-With, Content-Type, Accept',
      'Access-Control-Allow-Credentials' => 'true',
      'Access-Control-Max-Age' => 14.days.to_s
    )
  end

end
