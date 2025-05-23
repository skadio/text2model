% Parameters
int: num_items;
int: max_item;
int: num_bids;

set of int: ITEMS = 1..num_items;
set of int: BIDS  = 1..num_bids;

array[BIDS, ITEMS] of int: packages;   % 0 = item included in bid, 1 = item not included
array[BIDS] of int: bids;              % bid amount for each bid

% Variables
array[BIDS] of var 0..1: x;            % 1 if bid is accepted, 0 otherwise

% Constraints
constraint
  forall(j in ITEMS)(
    sum(i in BIDS)( (1 - packages[i,j]) * x[i] ) <= 1
  );

% Objective
solve maximize sum(i in BIDS)( bids[i] * x[i] );