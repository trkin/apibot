class Examples::PaginatedWithNextButtonController < Examples::ApplicationController
  def index
    @books = Book.page(params[:page]).per(Const.examples[:per_page])
  end

  def submit
    @books = Book.page(params[:page]).per(Const.examples[:per_page])
    render :index
  end

  def book
    @book = Book.find(params[:id])
  end
end
