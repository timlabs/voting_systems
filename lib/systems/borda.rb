def borda votes
  votes, options = normalize votes
  # calculate scores using Borda counts
  scores = borda_counts votes, options
  # sort the results and return the winner/s
  groups = options.group_by {|option| scores[option]}
  sorted = groups.sort_by {|score, tied| -score}
  # sorted.each {|score, tied| puts "#{score.to_f} #{tied}"}
  sorted.first[1]
end