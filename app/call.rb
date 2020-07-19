# frozen_string_literal: true

require_relative 'parser'

web_stats = Parser.new(ARGV[0]).read
p 'most visits:'
web_stats.most_visits
p 'most uniq:'
web_stats.most_uniq
