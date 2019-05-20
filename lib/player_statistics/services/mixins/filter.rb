# frozen_string_literal: true

module PlayerStatistics
  module Services
    module Mixins
      module Filter
        private

        def filter(table, ilike_column, filter)
          return { Sequel[table][:id] => filter } if integer?(filter)
          Sequel.ilike(Sequel[table][ilike_column], "%#{filter}%")
        end

        def integer?(string)
          Integer(string, exception: false)
        end
      end
    end
  end
end
