module WebmockHelper
  def stub_bot_start_url
    stub_request(:get, 'https://blog.trk.in.rs')
  end
end
