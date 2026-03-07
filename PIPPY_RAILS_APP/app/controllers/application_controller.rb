class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # ↓ これを追加にゃ！
  before_action :configure_permitted_parameters, if: :devise_controller?
def index
  # ここで毎回設定を書かないといけない...
  Gemini.configure { |config| config.service = 'gemini' } 
  client = Gemini.new(api_key: ENV['GEMINI_API_KEY'])
  @response = client.generate_content("こんにちは")
end
  protected

  def configure_permitted_parameters
    # サインアップ時に name も許可する設定だにゃ
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end