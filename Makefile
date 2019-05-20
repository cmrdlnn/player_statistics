debug:
	bin/irb

migrate:
	bin/migrate && PLAYER_STATISTICS_ENV=test bin/migrate

rollback:
	bin/migrate 0 && PLAYER_STATISTICS_ENV=test bin/migrate 0

seed:
	bin/seed

test:
	PLAYER_STATISTICS_ENV=test bundle exec rspec
