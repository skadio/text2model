% Parameters
int: num_items; % Number of items available in the auction
int: max_item; % Maximum item in the auction
int: num_bids; % Number of bids in the auction
array[1..num_bids, 1..num_items] of 0..1: packages; % Binary Matrix containing the packages (sets of items) for each bid
array[1..num_bids] of int: bids; % Array containing the bid amount for each bid

% Variables
array[1..num_bids] of var 0..1: x; % Binary decision variables indicating whether a bid is selected or not

% Constraints
% Ensure that any two bids in the subset do not share an item
constraint forall(i in 1..num_items)(
  sum(j in 1..num_bids)(x[j]*packages[j,i]) <= 1
);

% Objective
% Maximize the total bid amount
var int: total_bid = sum(i in 1..num_bids)(x[i]*bids[i]);
solve maximize total_bid;