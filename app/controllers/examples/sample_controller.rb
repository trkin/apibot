class Examples::SampleController < Examples::ApplicationController
  def index; end

  def non_ascii; end

  def show_non_ascii_in_link
    render html: 'ok'
  end

  def action_move_to_and_click; end
end
