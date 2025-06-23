module ErrorLog
  def log_error(result)
    add_error_log_and_save! result.message
    result
  end

  def add_error_log_and_save!(text)
    self.error_log = if error_log.present?
      "#{error_log} | #{text}"
    else
      text
    end
    save!
  end
end
