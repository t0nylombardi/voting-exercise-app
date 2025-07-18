module VoteHelpers
  def seed_votes(vote_tuples)
    vote_tuples.each do |user, candidate|
      create(:vote, user:, candidate:)
    end
  end

  def setup_basic_vote_distribution
    candidate_a = create(:candidate, name: "Artist A")
    candidate_b = create(:candidate, name: "Artist B")
    users = create_list(:user, 3)

    seed_votes([
      [users[0], candidate_a],
      [users[1], candidate_a],
      [users[2], candidate_b]
    ])

    {users:, candidate_a:, candidate_b:}
  end
end
