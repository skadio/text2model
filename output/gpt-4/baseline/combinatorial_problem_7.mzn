include "globals.mzn";

% Parameters
int: num_items; % Number of items
int: max_item; % Maximum item
int: num_bids; % Number of bids
array[1..num_bids, 1..num_items] of 0..1: packages; % Packages for each bid
array[1..num_bids] of int: bids; % Bid amount for each bid

% Decision variable
array[1..num_bids] of var 0..1: x; % Whether each bid is accepted or not

% Objective function
var int: total_bid = sum(i in 1..num_bids)(x[i]*bids[i]);
maximize total_bid;

% Constraints
constraint forall(i in 1..num_items)(
  sum(j in 1..num_bids)(x[j]*packages[j,i]) <= 1
);

solve satisfy;
output ["Total bid: ", show(total_bid), "\n",
        "Bids: ", show([if x[i] = 1 then i else 0 endif | i in 1..num_bids])];