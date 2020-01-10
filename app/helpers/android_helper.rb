module AndroidHelper
  def android_app?
    request.env['HTTP_USER_AGENT'] == Const.common[:short_name]
  end
end
