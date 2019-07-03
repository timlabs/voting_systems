def baldwin votes
  votes, options = normalize votes
  while true
    # calculate scores using Borda counts
    scores = borda_counts votes, options
    # group and sort the options by score
    groups = options.group_by {|option| scores[option]}
    sorted = groups.sort_by {|score, tied| -score}
    # puts
    # sorted.each {|score, tied| puts "#{score.to_f} #{tied}"}
    # find the options with the lowest score
    leasts = sorted.last[1]
    # if all remaining options are tied, they are the winners
    return leasts if leasts.size == options.size
    # remove the options with the lowest score
    votes.collect! {|count, ranking|
      [count, ranking.collect {|tied| tied - leasts}]
    }
    options -= leasts
  end
end