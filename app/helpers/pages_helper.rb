module PagesHelper
  def login_layout(login_title = nil)
    @login_title = login_title
    @login_layout = true
  end

  def login_layout?
    @login_layout
  end

  def login_title
    @login_title
  end

  def blank_layout
    @blank_layout = true
  end

  def blank_layout?
    @blank_layout
  end

  def title(name)
    @title = name
  end

  def fetch_title
    @title || fetch_breadcrumb_list.keys.last
  end

  def breadcrumb(list = {})
    @breadcrumb = list
  end

  def fetch_breadcrumb_list
    @breadcrumb || {}
  end
end
