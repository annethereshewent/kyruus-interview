class AddScoreToCheckins < ActiveRecord::Migration[6.1]
  def change
    add_column :check_ins, :question_1, :integer
    add_column :check_ins, :question_2, :integer
    add_column :check_ins, :screening_needed, :boolean
  end
end
