# frozen_string_literal: true

require_relative 'page_stats'
class WebStats
  attr_reader :page_stats

  def initialize
    @page_stats = {}
  end

  def add_page(page_name, ip)
    page_name = parse_name(page_name)

    return unless valid?(page_name, ip)

    if @page_stats[page_name].nil?
      @page_stats[page_name] = PageStats.new(page_name).add_ip(ip)
    else
      @page_stats[page_name].add_ip(ip)
    end
  end

  def most_visits
    sorted = sort('all_visits')
    sorted.each { |page| p "#{page[0]} #{page[1].all_visits} visits" }
  end

  def most_uniq
    sorted = sort('uniq_visits')
    sorted.each { |page| p "#{page[0]} #{page[1].uniq_visits} unique views" }
  end

  private

  def sort(attr)
    @page_stats.sort_by { |_, v| v.public_send(attr) }.reverse!
  end

  def valid?(page_name, ip)
    !(page_name.nil? || ip.nil? || page_name.empty? || ip.empty?)
  end

  def parse_name(name)
    name = name[1..-1] if name[0] == '/'
    name = name[0...-1] if name[-1] == '/'
    name
  end
end
