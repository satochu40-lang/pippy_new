class Memo < ApplicationRecord
  # 保存ボタンが押されたとき、データベースに書き込む直前にお返事を作るにゃ
  before_create :generate_pippy_response

  private

  def generate_pippy_response
    # AIの準備をするにゃ
   client = Gemini.new(credentials: { api_key: ENV['GEMINI_API_KEY'] } )
    model = client.model('gemini-1.5-flash')

    prompt = "あなたは三毛猫のPippyだにゃ。お母さんのメモに100文字以内で可愛くお返事してにゃ：#{self.content}"

    begin
      # AIにお返事をもらうにゃ
      result = model.generate_content({
        contents: [{ role: 'user', parts: [{ text: prompt }] }]
      })
      
      # お返事を response カラムに入れるにゃ
      # これで、SQLが走るときに一緒にお返事も保存されるにゃ！
      self.response = result.dig('candidates', 0, 'content', 'parts', 0, 'text')
      
    rescue => e
      self.response = "おはようにゃ！ちょっと寝ぼけてて繋がらなかったにゃ。でも応援してるにゃ！"
      Rails.logger.error "Gemini Error: #{e.message}"
    end
  end
end