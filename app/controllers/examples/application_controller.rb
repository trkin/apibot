class Examples::ApplicationController < ApplicationController
  layout 'examples'
  # GET /examples
  def index
  end

  def sample_error
    raise StandardError, 'This is sample_error on server'
  end
end
