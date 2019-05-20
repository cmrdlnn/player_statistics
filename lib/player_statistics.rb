# frozen_string_literal: true

Dir["#{__dir__}/player_statistics/models/**/*.rb"].each(&method(:require))
Dir["#{__dir__}/player_statistics/services/**/*.rb"].each(&method(:require))
