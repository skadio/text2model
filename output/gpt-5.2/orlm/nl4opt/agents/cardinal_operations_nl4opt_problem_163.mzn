% Parameters
int: interactions_cart = 70;          % Customer interactions per hour per cart server
int: interactions_hand = 85;          % Customer interactions per hour per hand server
int: refills_cart = 5;               % Refills per hour per cart server
int: refills_hand = 20;              % Refills per hour per hand server

int: min_cart_share_percent = 70;    % At least 70% of delivery shifts must be by cart
int: min_hand_servers = 3;           % At least 3 servers must deliver by hand
int: required_interactions = 4000;   % Target customer interactions per hour

% A safe upper bound on total servers needed (using the smaller interactions rate)
int: max_servers = required_interactions div min(interactions_cart, interactions_hand) + 10;

% Variables
var 0..max_servers: n_cart;          % Number of servers delivering by cart
var 0..max_servers: n_hand;          % Number of servers delivering by hand
var 0..(refills_cart * max_servers + refills_hand * max_servers): total_refills; % Total refills per hour

% Constraints
% Link total_refills to the decision variables (linear refills calculation)
constraint
  total_refills = refills_cart * n_cart + refills_hand * n_hand;

% Meet or exceed the required customer interactions per hour
constraint
  interactions_cart * n_cart + interactions_hand * n_hand >= required_interactions;

% Enforce minimum share of cart delivery shifts: n_cart / (n_cart + n_hand) >= 70%
% Implemented without division to avoid coercion/rounding issues:
constraint
  100 * n_cart >= min_cart_share_percent * (n_cart + n_hand);

% Ensure at least the minimum number of hand-delivery servers for direct service
constraint
  n_hand >= min_hand_servers;

% Objective
solve minimize total_refills;