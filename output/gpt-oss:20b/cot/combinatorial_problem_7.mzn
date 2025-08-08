% Parameters
int: num_items;
int: max_item;
int: num_bids;
array[1..num_bids, 1..num_items] of int: packages;
array[1..num_bids] of int: bids;

% Variables
array[1..num_bids] of var bool: selected;

% Constraints
constraint
    forall(i in 1..num_bids, j in 1..num_items) (packages[i,j] in 0..1);
constraint
    forall(i in 1..num_bids) (bids[i] >= 0);
constraint
    forall(j in 1..num_items) (
        sum(i in 1..num_bids) (selected[i] * (1 - packages[i,j])) <= 1
    );

% Objective
solve maximize sum(i in 1..num_bids) selected[i] * bids[i];