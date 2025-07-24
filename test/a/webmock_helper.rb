module WebmockHelper
  def stub_bot_start_url
    stub_request(:get, 'https://blog.trk.in.rs')
      .to_return(status: 200, body: <<~HTML)
    <html>
      <body>
        <a href='#' class='step'>Link</a>
      </body>
    </html>
    HTML
  end
end
