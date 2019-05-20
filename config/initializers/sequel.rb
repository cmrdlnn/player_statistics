# frozen_string_literal: true

require 'sequel'
require 'erb'
require 'yaml'

Sequel.extension :core_extensions

erb = IO.read("#{ROOT}/config/database.yml")
yaml = ERB.new(erb).result
options = YAML.safe_load(yaml, [], [], true)
env = ENV.fetch('PLAYER_STATISTICS_ENV') { 'development' }
db = Sequel.connect(options[env])

Sequel::Model.db = db
Sequel::Model.raise_on_save_failure = true
Sequel::Model.raise_on_typecast_failure = true

Sequel::Model.plugin :string_stripper
Sequel::Model.plugin :timestamps, update_on_create: true
