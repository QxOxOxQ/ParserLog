# frozen_string_literal: true

require_relative 'web_stats'

class Parser
  def initialize(log_path)
    @log_path = log_path
  end

  def read
    web_stats = WebStats.new
    file = File.open(@log_path)

    IO.foreach(file) do |line|
      page, ip = line.split(' ')
      web_stats.add_page(page, ip)
    end
    web_stats
  end
end
