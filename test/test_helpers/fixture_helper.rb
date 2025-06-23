# This code is from: https://trk.tools/rb/rails-tips/-/blob/main/test/test_helper.rb
# Instead of writing fixture methods
#   users(:user)
# we can use single word
#   fixture_user
#
# Note that in fixtures you can use ignored DEFAULTS key
# DEFAULTS: &DEFAULTS
#   name: My Fixture Name
# user:
#   <<: *DEFAULTS
#
# Note that you should not use the same label key in different fixtures since it
# will override

fixture_path = if ActiveSupport::TestCase.respond_to?(:fixture_paths)
  ActiveSupport::TestCase.fixture_paths.last
else
  # Old Rails does not support fixture_paths
  "#{Rails.root}/test/fixtures"
end
Dir.glob("#{fixture_path}/**/*.yml").each do |file_path|
  model_name = File.basename(file_path, ".yml") # e.g. "users"
  hash =
    begin
      YAML.load_file(file_path)
    rescue Psych::SyntaxError
      YAML.load(ERB.new(File.read(file_path)).result) # rubocop:disable Security/YAMLLoad
    end
  next unless hash.is_a? Hash

  # TODO: except DEFAULTS
  hash.each_key do |fixture_key|
    define_method "fixture_#{fixture_key}" do
      send model_name, fixture_key
    end
  end
end
