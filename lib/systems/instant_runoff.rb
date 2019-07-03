def instant_runoff votes
  votes, remaining = normalize votes
  while true
    votes.each {|count, ranking| ranking.delete []}
    # p votes

    # see how many times each option was ranked first
    scores = Hash.new 0
    votes.each {|count, ranking|
      tied = ranking.first
      tied.each {|option| scores[option] += count.quo tied.size}
    }

    # find the options which were ranked first the least
    groups = remaining.group_by {|option| scores[option]}
    # p groups
    leasts = groups.min_by {|score, tied| score}[1]

    # if all remaining options are tied, they are the winners
    return leasts if leasts.size == remaining.size

    # remove options which were ranked first the least
    votes.collect! {|count, ranking|
      [count, ranking.collect {|tied| tied - leasts}]
    }
    remaining -= leasts
  end
end