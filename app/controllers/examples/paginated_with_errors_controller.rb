class Examples::PaginatedWithErrorsController < Examples::ApplicationController
  def index
    @books = Book.page(params[:page]).per(Const.examples[:per_page])
    raise if params[:page].to_i == 3
  end

  def show
    @book = Book.find(params[:id])
    raise if params[:id].to_i == 12
  end
end
