=begin

This variant of ranked pairs is similar to the CIVS version.  We use winning
votes rather than margins to compare preferences, and we keep a preference as
long as it does not create a new cycle when considered in conjunction with
stricty stronger preferences.  Thus, tied preferences can be kept even if they
jointly introduce a cycle, as long as none of them does so individually.  We
depart from CIVS in the final ranking method.  Instead of finding successive
Schwartz sets, we just take the condensation of the graph.  The condensation in
this case has a unique topological ordering of equivalence classes, and that is
what we use for our ranking.

=end

require 'rgl/adjacency'
require 'rgl/condensation'
require 'rgl/topsort'

def results_from_pairs sorted_pairs
	graph = RGL::DirectedAdjacencyGraph.new
	sorted_pairs.each {|tied|
		# puts
		# puts "graph is: "
		# puts graph
		# puts "tied is #{tied}"
		keep = tied.select {|winner, loser|
			# keep if there is no path from loser to winner, meaning that this edge
			# will not create a cycle
			next true if not graph.has_vertex? loser
			not graph.bfs_iterator(loser).include? winner
		}
		# puts "keep is #{keep}"
		keep.each {|winner, loser| graph.add_edge winner, loser}
	}
	# puts "final graph is: "
	# puts graph
	# puts
	condensed = graph.condensation_graph
	# puts "condensed is "
	# condensed.edges.each {|edge| p edge.to_a}
	# puts
	results = condensed.topsort_iterator.to_a # should be unique
	# puts "results is "
	# p results
	results
end

def ranked_pairs votes
  votes, options = normalize votes
	scores = winning_votes votes # how many times each option beat each other option
	return options if scores.empty? # every vote ranked all the options the same
  # group and sort the pairs by winning votes
  groups = scores.keys.group_by {|key| scores[key]}
  sorted = groups.sort_by {|winning_votes, pairs| -winning_votes}
	# puts
  # p sorted
  sorted_pairs = sorted.transpose[1]
  # puts
	# puts 'sorted pairs:'
  # sorted_pairs.each {|tied| p tied}
  # puts
	# puts 'calculating results...'
	results = results_from_pairs sorted_pairs
	results.first.to_a
end