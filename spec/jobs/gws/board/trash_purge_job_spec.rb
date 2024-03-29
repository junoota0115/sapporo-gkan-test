require 'spec_helper'

describe Gws::Board::TrashPurgeJob, dbscope: :example do
  let(:site) { gws_site }
  let(:now) { Time.zone.now.beginning_of_minute }
  let!(:item1) { create(:gws_board_topic, cur_site: site, deleted: now - 7.days) }
  let!(:item2) { create(:gws_board_topic, cur_site: site, deleted: now - 2.years) }

  describe '#perform' do
    context '1 board topics are purged' do
      it do
        expect { described_class.bind(site_id: site.id).perform_now }.to change { Gws::Board::Topic.topic.count }.by(-1)

        expect(Job::Log.count).to eq 1
        Job::Log.first.tap do |log|
          expect(log.logs).to include(/INFO -- : .* Started Job/)
          expect(log.logs).to include(/INFO -- : .* Completed Job/)
        end
      end
    end

    context '2 board topics are purged' do
      it do
        expect { described_class.bind(site_id: site.id).perform_now(threshold: '7.days') }.to \
          change { Gws::Board::Topic.topic.count }.by(-2)

        expect(Job::Log.count).to eq 1
        Job::Log.first.tap do |log|
          expect(log.logs).to include(/INFO -- : .* Started Job/)
          expect(log.logs).to include(/INFO -- : .* Completed Job/)
        end
      end
    end

    context 'no board topics are purged' do
      it do
        expect { described_class.bind(site_id: site.id).perform_now(threshold: '3.years') }.to \
          change { Gws::Board::Topic.topic.count }.by(0)

        expect(Job::Log.count).to eq 1
        Job::Log.first.tap do |log|
          expect(log.logs).to include(/INFO -- : .* Started Job/)
          expect(log.logs).to include(/INFO -- : .* Completed Job/)
        end
      end
    end

    context 'when group trash_threshold is 7.days' do
      before do
        site.set(trash_threshold: 7)
        site.set(trash_threshold_unit: 'day')
      end

      it do
        expect { described_class.bind(site_id: site.id).perform_now }.to \
          change { Gws::Board::Topic.topic.count }.by(-2)

        expect(Job::Log.count).to eq 1
        Job::Log.first.tap do |log|
          expect(log.logs).to include(/INFO -- : .* Started Job/)
          expect(log.logs).to include(/INFO -- : .* Completed Job/)
        end
      end
    end

    context 'when group trash_threshold is 3.years' do
      before do
        site.set(trash_threshold: 3)
        site.set(trash_threshold_unit: 'years')
      end

      it do
        expect { described_class.bind(site_id: site.id).perform_now }.to change { Gws::Board::Topic.topic.count }.by(0)

        expect(Job::Log.count).to eq 1
        Job::Log.first.tap do |log|
          expect(log.logs).to include(/INFO -- : .* Started Job/)
          expect(log.logs).to include(/INFO -- : .* Completed Job/)
        end
      end
    end
  end
end
