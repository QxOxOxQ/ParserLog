# frozen_string_literal: true

class PageStats
  attr_reader :all_visits, :uniq_visits, :name, :ips

  def initialize(name)
    @all_visits = 0
    @uniq_visits = 0
    @ips = {}
    @name = name
  end

  def add_ip(ip)
    if @ips[ip].nil?
      @ips[ip] = 1
      @uniq_visits += 1
    else
      @ips[ip] += 1
    end
    @all_visits += 1
    self
  end
end
