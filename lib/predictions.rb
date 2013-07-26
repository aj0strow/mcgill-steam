module Predictions
  def self.generate_training_data
    PastRecord.all(:steam.not => nil).to_csv
  end
end