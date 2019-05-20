# frozen_string_literal: true

# Creation of players
players = FactoryBot.create_list(:player, 220)

# Creation of teams
teams = FactoryBot.create_list(:team, 10)

# Creation of game line ups of teams
line_ups = teams.map.with_index do |team, i|
  start_index = 22 * i
  end_index = start_index + 22

  FactoryBot
    .create_list(:line_up, 3, team: team)
    .each do |line_up|
      # Addition of relationships of line ups with players
      players[start_index...end_index]
        .sample(15)
        .each { |player| line_up.add_player(player) }
    end
end

# Creation of games between different line ups of teams
line_ups.shuffle.each_slice(2) do |line_ups1, line_ups2|
  line_ups1.each.with_index do |line_up, i|
    FactoryBot.create(:game,
                      line_up_1_id: line_up.id,
                      line_up_2_id: line_ups2[i].id)
  end
end

# Creation of possible performances
performances = FactoryBot.create_list(:performance, 8)
performances.concat(
  ['Пробежал 10+ км', 'Сделал 70+ % точных передач'].map do |description|
    FactoryBot.create(:performance, description: description)
  end
)

# Addition of relationships of players in line up with their performances
line_ups.flatten!.each do |line_up|
  line_up.players.each do |player|
    performances.sample(rand(performances.size)).each do |performance|
      Sequel::Model.db[:line_ups_players_performances].insert(
        %i[performance_id line_up_id player_id],
        [performance.id, line_up.id, player.id]
      )
    end
  end
end
