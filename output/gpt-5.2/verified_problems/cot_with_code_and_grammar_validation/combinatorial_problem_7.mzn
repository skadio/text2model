% Parameters
int: num_items;
int: max_item;
int: num_bids;

array[1..num_bids, 1..num_items] of int: packages; % 0 if item is in package, 1 otherwise
array[1..num_bids] of int: bids;

set of int: ITEMS = 1..num_items;
set of int: BIDS  = 1..num_bids;

% Variables
array[BIDS] of var 0..1: take;

% Constraints
constraint num_items <= max_item;

constraint
  forall(b in BIDS, i in ITEMS) (
    packages[b,i] in 0..1
  );

% No item can be allocated to more than one accepted bid
constraint
  forall(i in ITEMS) (
    sum(b in BIDS) (take[b] * (1 - packages[b,i])) <= 1
  );

% Objective: maximize total revenue
solve maximize sum(b in BIDS) (take[b] * bids[b]);