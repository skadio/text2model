% Parameters
int: num_items;
int: max_item;
int: num_bids;

array[1..num_bids, 1..num_items] of 0..1: packages;
array[1..num_bids] of int: bids;

set of int: ITEMS = 1..num_items;
set of int: BIDS  = 1..num_bids;

% Variables
array[BIDS] of var 0..1: x;   % x[b] = 1 if bid b is accepted, 0 otherwise

% Constraints
% No item can be allocated to more than one accepted bid
constraint
  forall(i in ITEMS)(
    sum(b in BIDS)( (1 - packages[b,i]) * x[b] ) <= 1
  );

% Objective
solve maximize sum(b in BIDS)( bids[b] * x[b] );