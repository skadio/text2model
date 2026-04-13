% Parameters (with values embedded)
int: interactions_cart = 70;
int: refills_cart = 5;

int: interactions_hand = 85;
int: refills_hand = 20;

int: required_interactions = 4000;

float: min_cart_fraction = 0.70;
int: min_hand_servers = 3;

% Variables
var 0..1000: cart;  % number of cart delivery shifts/servers per hour (upper bound chosen safely)
var 0..1000: hand;  % number of hand delivery shifts/servers per hour

% Constraints
constraint interactions_cart * cart + interactions_hand * hand >= required_interactions;

constraint hand >= min_hand_servers;

% At least 70% of shifts by cart: cart / (cart + hand) >= 0.70
% Linearized: 100*cart >= 70*(cart + hand)  -> 30*cart >= 70*hand
constraint 30 * cart >= 70 * hand;

% Objective
solve minimize refills_cart * cart + refills_hand * hand;