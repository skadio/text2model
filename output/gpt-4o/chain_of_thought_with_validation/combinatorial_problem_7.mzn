% Parameters
int: num_items;
int: max_item;
int: num_bids;
array[1..num_bids, 1..num_items] of int: packages; % 0 if item is included in the bid, 1 otherwise
array[1..num_bids] of int: bids;

% Variables
array[1..num_bids] of var 0..1: x;  % 1 if bid i is accepted

% Constraints
constraint
    forall (j in 1..num_items) (
        sum (i in 1..num_bids) ( (1 - packages[i,j]) * x[i] ) <= 1
    );

% Objective
solve maximize sum (i in 1..num_bids) ( bids[i] * x[i] );