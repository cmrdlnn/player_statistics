# Player statistics

This application was created to take into account statistics on the performance of players in matches.

## Development environment

To deploy for development you need to install a Vagrant version >= 2.1.2 and run the following command in your terminal:

```sh
vagrant up && vagrant ssh
```

This command will install the Ubuntu 18.04 LTS «Bionic Beaver» image, then configure the virtual machine based on it and install inside its ruby version manager `rbenv v1.1.2`, `Ruby v2.6.3` and `PostgeSQL 11` with development and test databases.

Test database will have the name `player_statistics_test` and development database will have the name `player_statistics`. The owner of these databases will have username `user_player_statistics` and password `123456` and superuser privileges.

After the setup you need to run the database migration to create the necessary tables. To run the migration use the following command:

```sh
make migrate
```

If you need to downgrade the migration use the following command:

```sh
make rollback
```

## Application launch

Application can do the following actions:

* Fullfill the player performance for specific game with command `./bin/fullfill_performance <player_id> <performance_id> <game_id>`
* Check if the player has completed the performance in a specific match with command `./bin/check_performance <player_id> <performance_id> <game_id>`
* Select the top-5 players for a specific performance in a particular team and for all teams in general `./bin/check_performance <performance_id> <team_id (not required)>`

You can fill the database with test data by following command:

```sh
make seed
```

## Tests

To run tests use the following command:

```sh
make test
```

## Debug

To start the debugging console with the loaded application code, use the following command:

```sh
make debug
```

## Environment variables

* `PLAYER_STATISTICS_DB_USER` - database username
* `PLAYER_STATISTICS_DB_PASS` - user password
* `PLAYER_STATISTICS_DB_HOST` - host of the database
* `PLAYER_STATISTICS_DB_PORT` - port of the database
* `PLAYER_STATISTICS_DB_NAME` - name of the database
