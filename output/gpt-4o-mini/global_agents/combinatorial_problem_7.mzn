include "globals.mzn";

int: num_items;                          % Number of items available in the auction
int: num_bids;                            % Number of bids in the auction
array[1..num_bids] of int: bids;         % Array containing the bid amounts
array[1..num_bids, 1..num_items] of var 0..1: packages; % Binary matrix for packages

/* Variables */
array[1..num_bids] of var 0..1: selected; % 1 if the bid is selected, 0 otherwise

/* Constraints */
% Ensure that no two selected bids share an item
constraint forall(i, j in 1..num_bids where i < j)(
    selected[i] + selected[j] <= 1 + sum(k in 1..num_items)(packages[i, k] + packages[j, k])
);

/* Objective: Maximize total bid amount */
var int: total_bid = sum(i in 1..num_bids)(selected[i] * bids[i]);
solve maximize total_bid;

/* Output */
output [ "Total Bid = ", show(total_bid), "\nSelected Bids = ", show(selected), "\n" ];