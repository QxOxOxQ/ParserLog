# frozen_string_literal: true

require_relative '../app/parser'
describe Parser do
  describe '#read' do
    let(:parser) { described_class.new('spec/fixtures/webserver.log') }
    let(:web_stats_double) { instance_double('WebStats') }

    before do
      allow(WebStats).to receive(:new)
        .and_return(web_stats_double)
      allow(web_stats_double).to receive(:add_page).and_return('')
    end

    it 'returns web_stats object' do
      expect(parser.read).to eq web_stats_double
    end

    it 'receive 1000 times method add page' do
      expect(web_stats_double).to receive(:add_page).exactly(1000).times
      parser.read
    end
  end
end
