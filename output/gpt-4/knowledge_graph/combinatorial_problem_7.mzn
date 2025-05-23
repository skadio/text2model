include "globals.mzn";

% Parameters
int: num_items; % Number of items available in the auction
int: max_item; % Maximum item in the auction
int: num_bids; % Number of bids in the auction
array[1..num_bids, 1..num_items] of 0..1: packages; % Binary Matrix containing the packages (sets of items) for each bid, 0 if contained, 1 if not
array[1..num_bids] of int: bids; % Array containing the bid amount for each bid

% Variables
array[1..num_bids] of var 0..1: x; % Binary decision variables indicating whether a bid is accepted or not

% Constraints
constraint forall(i in 1..num_bids, j in i+1..num_bids) (
  sum(k in 1..num_items) (packages[i,k] * packages[j,k] * x[i] * x[j]) = 0
); % Any two bids in the subset do not share an item

% Objective
var int: total_bid = sum(i in 1..num_bids) (bids[i] * x[i]); % Total bid amount
solve maximize total_bid;

% Output
output [ "Total bid: ", show(total_bid), "\n" ] ++
[ if fix(x[i]) = 1 then "Bid " ++ show(i) ++ " is accepted\n" else "" endif | i in 1..num_bids ];