class Examples::PaginatedWithLinksController < Examples::ApplicationController
  def index
    @books = Book.page(params[:page]).per(Const.examples[:per_page])
  end

  def book
    @book = Book.find(params[:id])
  end
end
