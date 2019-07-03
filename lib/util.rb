def borda_counts votes, options
  # calculate the Borda count of each option
  scores = Hash.new 0
  votes.each {|count, ranking|
    # add to the scores
    remaining = options.size
    ranking.each_with_index {|tied, i|
      # each tied option gets the average of their possible ranks
      average = remaining - (tied.size - 1) / 2r
      tied.each {|option| scores[option] += count * average}
      remaining -= tied.size
    }
    raise unless remaining == 0 # sanity check
  }
  scores
end

def convert_legrand legrand
  # format from https://www.cse.wustl.edu/~legrand/rbvote/calc.html
  legrand.each_line.collect {|line|
    comment = line.index '#'
    line = line[0...comment] if comment
    fields = line.strip.split ':'
    case fields.size
      when 0 then next
      when 1
        # no count provided, so default to 1
        count = 1
        ranks = fields[0]
      when 2
        count = fields[0].to_i
        ranks = fields[1]
      else raise 'only one colon allowed per line'
    end
    groups = ranks.split '>'
    ranking = groups.collect {|group| group.split '='}
    [count, ranking]
  }.compact
end

def normalize votes
  # normalize votes and return along with all options that appeared
  votes = convert_legrand votes if votes.is_a? String
  raise 'votes must contain at least one option' if votes.empty?
  raise 'each vote must have the form [count, ranking]' if votes.find {|vote| vote.size != 2}
  options = votes.transpose[1].flatten.uniq
  votes = votes.collect {|count, ranking|
    raise 'ranking must be an array' unless ranking.is_a? Array
    # treat missing options as tied for last place
    missing = options - ranking.flatten
    ranking = ranking + [missing] unless missing.empty?
    # make sure no options appear twice
    raise 'duplicate option in ranking' unless ranking.flatten.size == options.size
    # normalize single ranks as singleton ties
    ranking = ranking.collect {|x| x.is_a?(Array) ? x : [x]}
    # remove empty ties
    ranking = ranking.select {|tied| not tied.empty?}
    [count, ranking]
  }
  [votes, options]
end

def winning_votes votes
  # see how many times each option beat each other option
  scores = Hash.new 0
  votes.each {|count, ranking|
    (0...ranking.size).each {|i|
      (i+1...ranking.size).each {|j|
        ranking[i].each {|option1|
          ranking[j].each {|option2|
            scores[[option1, option2]] += count
          }
        }
      }
    }
  }
  scores
end