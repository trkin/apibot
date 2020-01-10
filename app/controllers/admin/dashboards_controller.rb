class Admin::DashboardsController < Admin::BaseController
  def show; end

  def sample_error
    raise 'This is sample_error on server'
  end

  def sample_error_in_javascript
    render layout: true, html: %(
      Calling manual_js_error_now
      <script>
        function manual_js_error_now_function() {
          manual_js_error_now
        }
        console.log('calling manual_js_error_now');
        manual_js_error_now_function();
        // you can also trigger error on window.onload = function() { manual_js_error_onload }
      </script>
      <br>
      <button onclick="trigger_js_error_on_click">Trigger error on click</button>
      <a href="#{sample_error_in_javascript_ajax_admin_dashboard_path}" data-remote="true">Trigger error in ajax</a>
    ).html_safe
  end

  def sample_error_in_javascript_ajax
    render js: %(
      console.log("starting sample_error_in_javascript_ajax");
      sample_error_in_javascript_ajax
    )
  end

  def sample_error_in_sidekiq
    TaskWithErrorJob.perform_later
    render plain: 'TaskWithErrorJob in queue, please run: bundle exec sidekiq -C config/sidekiq.yml'
  end
end
