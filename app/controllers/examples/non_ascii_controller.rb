class Examples::NonAsciiController < Examples::ApplicationController
  def index
  end

  def show
    render html: 'ok'
  end
end
