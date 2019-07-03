def coombs votes
  # this implements the version of Coombs in which elimination proceeds
  # regardless of whether a candidate is ranked first by a majority of voters
  votes, remaining = normalize votes
  while true
    votes.each {|count, ranking| ranking.delete []}
    # p votes

    # see how many times each option was ranked last
    scores = Hash.new 0
    votes.each {|count, ranking|
      tied = ranking.last
      tied.each {|option| scores[option] += count.quo tied.size}
    }

    # find the options which were ranked last the most
    groups = remaining.group_by {|option| scores[option]}
    # p groups
    mosts = groups.max_by {|score, tied| score}[1]

    # if all remaining options are tied, they are the winners
    return mosts if mosts.size == remaining.size

    # remove options which were ranked last the most
    votes.collect! {|count, ranking|
      [count, ranking.collect {|tied| tied - mosts}]
    }
    remaining -= mosts
  end
end