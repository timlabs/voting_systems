# voting_systems

Ruby gem implementing various voting systems.

Each voting system (e.g. `borda`) takes a set of preferences as input.  Each preference is a ranking of alternatives.  The output is the winning alternative(s).

Ties and omissions are allowed in the preferences.  Omitted alternatives are considered least preferred.

All of the systems are deterministic.  There is no random tie-breaking.  If the result is a tie, all of the tied alternatives will be returned.

Voting systems:

* baldwin
* borda
* bucklin
* coombs
* copeland
* instant_runoff
* ranked_pairs

See https://www.cse.wustl.edu/~legrand/rbvote/desc.html for descriptions of the systems.

## Usage

`require 'voting_systems'`

There are two input formats.  The first looks like:

```
votes = '4:A>B>C
         5:B>C>A
         2:C=A>B'
```

There are 4 votes with the preference A>B>C, 5 votes with B>C>A, and 2 votes with C=A>B (meaning that C and A are equally preferred, and both are preferred to B).

The second looks like:

```
votes = [
  [4, ['A','B','C']],
  [5, ['B','C','A']],
  [2, [['C','A'],'B']],
]
```

Here, the alternatives need not be strings, but can be any object.

To find the winner(s) for a given system:

```
winners = borda votes

=> ["B"]
```