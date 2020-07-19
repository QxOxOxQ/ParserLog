# frozen_string_literal: true

require_relative '../app/web_stats'
describe WebStats do
  let(:web_stat) { described_class.new }

  describe '#add_page' do
    let(:page_name) { '/page/3' }
    let(:parsed_page_name) { 'page/3' }
    let(:ip) { '123.123.123' }
    let(:page_stats_double) { instance_double('PageStats') }

    before do
      allow(PageStats).to receive(:new)
        .with(parsed_page_name)
        .and_return(page_stats_double)
      allow(page_stats_double).to receive(:add_ip)
        .with(ip)
        .and_return(page_stats_double)
    end

    context 'when add first page' do
      before { web_stat.add_page(page_name, ip) }

      it 'add PageStat object to page_stats' do
        expect(web_stat.page_stats[parsed_page_name]).to eq page_stats_double
      end

      it 'page_stats received add_ip' do
        expect(page_stats_double).to have_received(:add_ip).with(ip)
      end
    end

    context 'when add this same page' do
      before do
        web_stat.instance_variable_set('@page_stats',
                                       parsed_page_name => page_stats_double)
        web_stat.add_page(page_name, ip)
      end

      it 'does not add new PageStat object to page_stats' do
        expect(web_stat.page_stats.size).to eq 1
        expect(PageStats).not_to have_received(:new)
      end

      it 'page_stats received add_ip' do
        expect(page_stats_double).to have_received(:add_ip).with(ip)
      end
    end

    context 'when add other page' do
      let(:other_page_name) { '/page/5' }
      let(:paresed_other_page_name) { 'page/5' }

      before do
        web_stat.instance_variable_set('@page_stats',
                                       paresed_other_page_name => page_stats_double)
        web_stat.add_page(page_name, ip)
      end

      it 'page_stats received add_ip' do
        expect(PageStats).to have_received(:new)
        expect(page_stats_double).to have_received(:add_ip).with(ip)
      end

      it 'add PageStat object to page_stats' do
        expect(web_stat.page_stats.size).to eq 2
        expect(web_stat.page_stats[parsed_page_name]).to eq page_stats_double
      end
    end
  end

  describe '#most_visits' do
    let(:page_stats_double) { instance_double('PageStats', name: '0', all_visits: 0) }
    let(:page_stats_double1) { instance_double('PageStats', name: '1', all_visits: 1) }
    let(:page_stats_double2) { instance_double('PageStats', name: '2', all_visits: 5) }

    before do
      web_stat.instance_variable_set('@page_stats',
                                     '0' => page_stats_double,
                                     '2' => page_stats_double2,
                                     '1' => page_stats_double1)
    end

    it 'returns hash with ordered ASC pages' do
      expect(web_stat.most_visits).to eq(
        [
          ['2', page_stats_double2],
          ['1', page_stats_double1],
          ['0', page_stats_double]
        ]
      )
    end
  end

  describe '#most_uniq' do
    let(:page_stats_double) { instance_double('PageStats', name: '0', uniq_visits: 0) }
    let(:page_stats_double1) { instance_double('PageStats', name: '1', uniq_visits: 1) }
    let(:page_stats_double2) { instance_double('PageStats', name: '2', uniq_visits: 5) }

    before do
      web_stat.instance_variable_set('@page_stats',
                                     '0' => page_stats_double,
                                     '2' => page_stats_double2,
                                     '1' => page_stats_double1)
    end

    it 'returns hash with ordered ASC pages' do
      expect(web_stat.most_uniq).to eq(
        [
          ['2', page_stats_double2],
          ['1', page_stats_double1],
          ['0', page_stats_double]
        ]
      )
    end
  end
end
