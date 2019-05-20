# frozen_string_literal: true

module PlayerStatistics
  module Services
    module Players
      class FullfillPerformance
        module Errors
          class PlayerGameMissing < ArgumentError
            def initialize(args)
              super("Player `#{args[0]}` didn't play in `#{args[1]}` game")
            end
          end

          class NoPerformance < ArgumentError
            def initialize(performance)
              super("Couldn't find `#{performance}` performance")
            end
          end

          class AlreadyFullfilled < ArgumentError
            def initialize(args)
              super(
                "`#{args[2]}` performance already marked as fullfilled by " \
                "player `#{args[0]}` in game `#{args[1]}`"
              )
            end
          end
        end
      end
    end
  end
end
