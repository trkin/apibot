# This code is from: https://trk.tools/app/trk-readme-source-links/-/blob/main/lib/hash_utils.rb
module HashUtils
  # We need extend so we can use HashUtils.method instead of HashUtils::method
  extend self
  # Add previous keys to hash, usefull for nested json
  #   my_hash = { a: { b: 1 } }
  #   HashUtils.hash_add_keys my_hash
  #     {"a"=>{"a b"=>1}}
  #
  # Save and load hash from file:
  #   File.write 'tmp/my_hash', my_hash.to_json, mode: 'a'
  #   my_hash = JSON.parse File.read("tmp/my_hash")
  #
  # Pretty print json
  #   my_hash = { "a" => { b: "2" } }
  #   puts JSON.pretty_generate my_hash
  #   # in html
  #   <%= JSON.pretty_generate(my_hash).gsub("\n", "<br>").gsub(" ", "&nbsp;").html_safe %>
  #
  # Use with colorize:
  #   JSON.pretty_generate(HashUtils.hash_add_keys(my_hash)).colorize "my_search", only: true
  def self.hash_add_keys(object, path_to_here = "")
    case object
    when Hash
      object.each_with_object({}) do |(k, v), a|
        new_path = "#{path_to_here} #{k}".strip
        a[new_path] = hash_add_keys(v, new_path)
      end
    when Array
      object.map.with_index do |o, i|
        new_path = "#{path_to_here} #{i}".strip
        hash_add_keys o, new_path
      end
    else
      object
    end
  end

  # https://fractaledmind.com/articles/safely-accessing-values-from-a-nested-hash-again/
  # Since dig can raise exception:
  # hash = { a: { b: "string" }, items: [{"id": "first"}] }
  # hash.dig :a, :b, :c
  # => String does not have #dig method (TypeError)
  # safe_dig does not raise
  # HashUtils.safe_dig hash, %w[a b c]
  # => nil
  # and also works for arrays "0" is [0]
  # HashUtils.safe_dig hash, %w[items 0 id]
  # => first
  def self.safe_dig(hash, keypath, default = nil)
    stringified_hash = JSON.parse(hash.to_json)
    stringified_keypath = keypath.map(&:to_s)

    stringified_keypath.reduce(stringified_hash) do |accessible, key|
      if accessible.is_a?(Array) && key == "0"
        accessible[0]
      else
        return default unless accessible.is_a? Hash
        return default unless accessible.key? key

        accessible[key]
      end
    end
  end
end
