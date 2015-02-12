module MyApi
  module Helpers
    module ProjectsHelper
      def try_if_authorized
        begin
          yield
        rescue => e
          error!('quota_excedeed',403) if e.message == 'quota_excedeed'
          error!(e.message)
        end
      end
    end
  end
end
