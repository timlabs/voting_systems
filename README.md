# voting_systems

Ruby gem implementing various voting systems.

Each voting system (e.g. `borda`) takes a set of preferences as input.  Each preference is a ranking of alternatives.  The output is the winning alternative(s).

Ties and omissions are allowed in the preferences.  Omitted alternatives are considered least preferred.

All of the systems are deterministic.  There is no random tie-breaking.  If the result is a tie, all of the tied alternatives will be returned.

Supported systems:

method name    | description
---            | ---
baldwin        | [Baldwin method](https://en.wikipedia.org/wiki/Nanson%27s_method#Baldwin_method)
borda          | [Borda count](https://en.wikipedia.org/wiki/Borda_count)
bucklin        | [Bucklin voting](https://en.wikipedia.org/wiki/Bucklin_voting)
coombs         | [Coombs' method](https://en.wikipedia.org/wiki/Coombs%27_method)
copeland       | [Copeland's method](https://en.wikipedia.org/wiki/Copeland%27s_method)
instant_runoff | [Instant-runoff voting](https://en.wikipedia.org/wiki/Instant-runoff_voting)
ranked_pairs   | [Ranked pairs](https://en.wikipedia.org/wiki/Ranked_pairs)

## Installation

```
gem install voting_systems
```

## Usage

```ruby
require 'voting_systems'
```

There are two input formats.  The first looks like:

```ruby
votes = '4:A>B>C
         5:B>C>A
         2:C=A>B'
```

There are 4 votes with the preference A>B>C, 5 votes with B>C>A, and 2 votes with C=A>B (meaning that C and A are equally preferred, and both are preferred to B).

The second looks like:

```ruby
votes = [
  [4, ['A','B','C']],
  [5, ['B','C','A']],
  [2, [['C','A'],'B']],
]
```

Here, the alternatives need not be strings, but can be any object.

To find the winner(s) for a given system (e.g. `borda`):

```ruby
winners = borda votes
=> ["B"]
```

## Author

Tim Smith ([timlabs.org](http://timlabs.org))
