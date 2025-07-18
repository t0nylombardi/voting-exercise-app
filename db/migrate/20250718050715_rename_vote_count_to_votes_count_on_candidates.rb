class RenameVoteCountToVotesCountOnCandidates < ActiveRecord::Migration[7.2]
  def change
    rename_column :candidates, :vote_count, :votes_count
  end
end
