# frozen_string_literal: true

require 'dotenv'

env = ENV.fetch('PLAYER_STATISTICS_ENV') { 'development' }

Dotenv.load("#{ROOT}/.env.#{env}")
