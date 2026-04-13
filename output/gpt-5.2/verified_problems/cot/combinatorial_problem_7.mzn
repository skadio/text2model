% Parameters
int: num_items;
int: max_item;
int: num_bids;

array[1..num_bids, 1..num_items] of int: packages;
array[1..num_bids] of int: bids;

% Variables
array[1..num_bids] of var 0..1: take;

% Constraints
constraint forall(b in 1..num_bids, i in 1..num_items)(
  packages[b,i] >= 0 /\ packages[b,i] <= 1
);

constraint forall(b in 1..num_bids)(
  bids[b] >= 0
);

% No item can be allocated to more than one accepted bid.
% packages[b,i] = 0 means item i is included in bid b.
constraint forall(i in 1..num_items)(
  sum(b in 1..num_bids)(take[b] * (1 - packages[b,i])) <= 1
);

% Objective
solve maximize sum(b in 1..num_bids)(take[b] * bids[b]);