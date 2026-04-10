% Parameters
int: num_items;                     % Number of items available in the auction
int: max_item;                      % Maximum item index/label in the auction (as provided in data)
int: num_bids;                      % Number of bids

array[1..num_bids, 1..num_items] of int: packages;
% Binary matrix describing each bid's package over items:
% packages[b,i] = 0 means item i is contained in bid b
% packages[b,i] = 1 means item i is NOT contained in bid b

array[1..num_bids] of int: bids;    % Bid amount for each bid

% Variables
array[1..num_bids] of var 0..1: take_bid;
% take_bid[b] = 1 if bid b is accepted, 0 otherwise

var 0..sum(bids): total_revenue;
% Total revenue from accepted bids (bounded by sum of all bids)

% Constraints

% --- Item disjointness: no item can be allocated to more than one accepted bid ---
constraint
  forall(i in 1..num_items) (
    sum(b in 1..num_bids) (take_bid[b] * (1 - packages[b,i])) <= 1
  );

% --- Revenue definition: total revenue equals sum of accepted bid amounts ---
constraint
  total_revenue = sum(b in 1..num_bids) (take_bid[b] * bids[b]);

% --- Consistency check: max_item should match the provided number of items (if intended) ---
constraint
  max_item = num_items;

% Objective
solve maximize total_revenue;