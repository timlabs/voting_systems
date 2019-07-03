def copeland votes
  # implements standard Copeland (pairwise victories minus pairwise defeats)
  votes, options = normalize votes
  scores = winning_votes votes # how many times each option beat each other option
  # puts "scores: #{scores}"
  # calculate pairwise victories and pairwise defeats
  victories, defeats = {}, {}
  options.each {|option1|
    victories[option1] = options.select {|option2|
      scores[[option1, option2]] > scores[[option2, option1]]
    }
    defeats[option1] = options.select {|option2|
      scores[[option1, option2]] < scores[[option2, option1]]
    }
  }
  # puts "victories: #{victories}"
  # puts "defeats: #{defeats}"
  # calculate results
  groups = options.group_by {|option|
    victories[option].size - defeats[option].size
  }
  sorted = groups.sort_by {|margin, tied| -margin}
  # puts 'results:'
  # sorted.each {|margin, tied| puts "  #{tied} --> #{margin}"}
  sorted.first[1]
end