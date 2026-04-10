% Parameters
int: interactions_cart = 70;
int: refills_cart = 5;

int: interactions_hand = 85;
int: refills_hand = 20;

int: min_cart_percent = 70; % at least 70% by cart
int: min_hand_servers = 3;

int: required_interactions = 4000;

% Upper bounds (safe bounds derived from requirement)
int: max_cart = required_interactions div interactions_cart + 100;
int: max_hand = required_interactions div interactions_hand + 100;

% Variables
var 0..max_cart: cart;
var 0..max_hand: hand;
var 0..(refills_cart*max_cart + refills_hand*max_hand): total_refills;

% Constraints
constraint interactions_cart * cart + interactions_hand * hand >= required_interactions;

constraint hand >= min_hand_servers;

% At least 70% of shifts by cart: cart / (cart+hand) >= 0.70
% Avoid division: 100*cart >= 70*(cart+hand)  <=> 30*cart >= 70*hand
constraint 30 * cart >= min_cart_percent * hand;

constraint total_refills = refills_cart * cart + refills_hand * hand;

% Objective
solve minimize total_refills;