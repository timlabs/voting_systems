def scores_for_places votes, places
  # Add up votes for each option, including 1st-place votes, 2nd-place votes,
  # and so on up to k-place votes, where k = places.
  scores = Hash.new 0
  votes.each {|count, ranking|
    remaining = places
    ranking.each {|tied|
      if remaining > tied.size
        # each tied option uses up one "place"
        tied.each {|option| scores[option] += count}
        remaining -= tied.size
      else
        # not enough remaining "places" to go around, so give each tied option
        # an equal fraction of what there is
        tied.each {|option| scores[option] += count * (remaining.quo tied.size)}
        break
      end
    }
  }
  scores
end

def bucklin votes
  votes, options = normalize votes
  sum_of_counts = votes.transpose[0].inject 0, :+
  (1..options.size).each {|places|
    # count the votes up to places
    scores = scores_for_places votes, places
    # find the winners
    groups = options.group_by {|option| scores[option]}
    # p groups
    best = groups.max_by {|score, tied| score}
    # if the best group has a majority, it is the winner
    return best[1] if best[0] > sum_of_counts / 2r
  }
  raise # should never get here, by the pigeonhole principle
end