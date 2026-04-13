% Parameters
int: num_items;
int: max_item;
int: num_bids;

array[1..num_bids, 1..num_items] of int: packages; % 0/1 incidence
array[1..num_bids] of int: bids;

% Variables
array[1..num_bids] of var 0..1: take;

var int: revenue;

% Constraints
constraint forall(b in 1..num_bids, i in 1..num_items) (
  packages[b,i] >= 0 /\ packages[b,i] <= 1
);

constraint forall(b in 1..num_bids) (
  bids[b] >= 0
);

constraint forall(i in 1..num_items) (
  sum(b in 1..num_bids)( take[b] * packages[b,i] ) <= 1
);

constraint revenue = sum(b in 1..num_bids)( take[b] * bids[b] );

% Objective
solve maximize revenue;