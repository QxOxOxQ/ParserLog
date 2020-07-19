# frozen_string_literal: true

require_relative '../app/page_stats'

describe PageStats do
  describe 'new object' do
    context 'when build without name' do
      it 'raise ArgumentError' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context 'when build with name' do
      let!(:page_stats) { described_class.new('page') }

      it 'has passed name' do
        expect(page_stats.name).to eq 'page'
      end

      it 'has all_visits attr equal 0' do
        expect(page_stats.all_visits).to eq(0)
      end

      it 'has uniq_visits attr equal 0' do
        expect(page_stats.uniq_visits).to eq(0)
      end

      it 'has ips attr equal {}' do
        expect(page_stats.ips).to eq({})
      end
    end
  end

  describe '#add_ip' do
    let(:ip) { '123.123.123' }
    let(:page_stats) { described_class.new('page') }

    context 'when page does not has any ip' do
      before { page_stats.add_ip(ip) }

      it('all_visits equal 1') { expect(page_stats.all_visits).to eq 1 }
      it('uniq_visits equal 1') { expect(page_stats.uniq_visits).to eq 1 }
      it('uniq_visits equal 1') { expect(page_stats.ips).to eq ip => 1 }
    end

    context 'when page has this ip' do
      before do
        page_stats.instance_variable_set('@ips', { ip => 1 })
        page_stats.instance_variable_set('@all_visits', 1)
        page_stats.instance_variable_set('@uniq_visits', 1)
        page_stats.add_ip(ip)
      end

      it('increase by 1 all_visits') { expect(page_stats.all_visits).to eq 2 }
      it('do not increase uniq_visits') { expect(page_stats.uniq_visits).to eq 1 }
      it('do not add new ips') { expect(page_stats.ips.size).to eq 1 }
      it('increase by 1 ips stats') { expect(page_stats.ips[ip]).to eq 2 }
    end

    context 'when page has other ip' do
      let(:other_ip) { "#{ip}.1" }

      before do
        page_stats.instance_variable_set('@ips', { other_ip => 1 })
        page_stats.instance_variable_set('@all_visits', 1)
        page_stats.instance_variable_set('@uniq_visits', 1)
        page_stats.add_ip(ip)
      end

      it('increase by 1 all_visits') { expect(page_stats.all_visits).to eq 2 }
      it('increase uniq_visits') { expect(page_stats.uniq_visits).to eq 2 }
      it('add new ips') { expect(page_stats.ips.size).to eq 2 }
      it('increase by 1 this ips stats') { expect(page_stats.ips[ip]).to eq 1 }
      it('do not increase other ip stats') { expect(page_stats.ips[other_ip]).to eq 1 }
    end
  end
end
