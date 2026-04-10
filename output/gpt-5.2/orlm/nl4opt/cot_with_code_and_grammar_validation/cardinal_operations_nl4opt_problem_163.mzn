% Parameters
int: interactions_cart = 70;
int: refills_cart = 5;

int: interactions_hand = 85;
int: refills_hand = 20;

int: min_cart_pct = 70;          % at least 70% by cart
int: min_hand_servers = 3;       % at least 3 by hand
int: required_interactions = 4000;

% Variables
var 0..required_interactions: cart_servers;
var 0..required_interactions: hand_servers;
var 0..(refills_cart*required_interactions + refills_hand*required_interactions): total_refills;

% Constraints
constraint interactions_cart * cart_servers + interactions_hand * hand_servers >= required_interactions;

constraint hand_servers >= min_hand_servers;

% cart_servers / (cart_servers + hand_servers) >= 0.70
% 100*cart >= 70*(cart+hand)  -> 30*cart >= 70*hand
constraint 30 * cart_servers >= min_cart_pct * hand_servers;

constraint total_refills = refills_cart * cart_servers + refills_hand * hand_servers;

% Objective
solve minimize total_refills;