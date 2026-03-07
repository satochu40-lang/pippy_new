class AddReplyToMemos < ActiveRecord::Migration[7.1]
  def change
    add_column :memos, :reply, :text
  end
end
