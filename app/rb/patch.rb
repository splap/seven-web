module Sinatra
  module AssetPack
    module BusterHelpers
      extend self

      def cache_buster_hash(*files)

        # compact files before sort to remove nil file items. 
        # caused nil string comparison exception on heroku, none locally
        content = files.compact.sort.map do |f|
          Digest::MD5.file(f).hexdigest if f.is_a?(String) && File.file?(f)
        end

        Digest::MD5.hexdigest(content.join) if content.any?
      end
    end
  end
end

