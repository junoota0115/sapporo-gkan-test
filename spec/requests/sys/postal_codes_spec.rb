require 'spec_helper'

describe Sys::PostalCodesController, type: :request, dbscope: :example do
  let!(:user) { sys_user }
  let!(:file) { Rack::Test::UploadedFile.new("#{::Rails.root}/spec/fixtures/sys/postal_code.zip", nil, true) }
  let!(:login_path) { sns_login_path(format: :json) }
  let!(:correct_login_params) do
    {
      item: {
        email: user.email,
        password: SS::Crypto.encrypt("pass", type: "AES-256-CBC"),
        encryption_type: "AES-256-CBC"
      }
    }
  end

  before do
    post login_path, params: correct_login_params
    SS.config.replace_value_at(:env, :json_datetime_format, "%Y/%m/%d %H:%M:%S")
  end

  describe 'GET #index' do
    context 'When postal_code is nothing' do
      before do
        get sys_postal_codes_path
      end

      it { expect(assigns[:model]).to eq Sys::PostalCode }
      it { expect(assigns[:cur_user]).to eq user }
      it { expect(response.status).to eq 200 }
      it { expect(assigns[:items].first).to be_nil }
    end

    context 'When #index' do
      before do
        Sys::PostalCode::OfficialCsvImportJob.import_from_zip("#{::Rails.root}/spec/fixtures/sys/postal_code.zip")
        get sys_postal_codes_path
      end

      it { expect(assigns[:model]).to eq Sys::PostalCode }
      it { expect(assigns[:cur_user]).to eq user }
      it { expect(response.status).to eq 200 }
      it { expect(assigns[:items].first).not_to be_nil }
      it { expect(response.body).to include '<span class="prefecture">東京都</span>' }
    end
  end

  describe 'GET #download' do
    context 'When #download' do
      before do
        post download_sys_postal_codes_path
      end

      it { expect(assigns[:model]).to eq Sys::PostalCode }
      it { expect(assigns[:cur_user]).to eq user }
      it { expect(response.status).to eq 200 }
    end
  end

  describe 'POST #import' do
    context 'When item[:in_official_csv] is 0' do
      before do
        post import_sys_postal_codes_path, params: {
          item: {
            in_file: file,
            in_official_csv: '0'
          }
        }
      end

      it { expect(response).to redirect_to sys_postal_codes_path }
      it do
        get sys_postal_codes_path
        I18n.with_locale(user.lang.presence.try(:to_sym) || I18n.default_locale) do
          expect(response.body).to include I18n.t("ss.notice.started_import")
        end
      end
    end

    context 'When item[:in_official_csv] is 1' do
      before do
        post import_sys_postal_codes_path, params: {
          item: {
            in_file: file,
            in_official_csv: '1'
          }
        }
      end

      it { expect(response).to redirect_to sys_postal_codes_path }
      it do
        get sys_postal_codes_path
        I18n.with_locale(user.lang.presence.try(:to_sym) || I18n.default_locale) do
          expect(response.body).to include I18n.t("ss.notice.started_import")
        end
      end
    end
  end
end
