% Parameters
int: golf_cart_capacity = 4;          % Guests per golf cart
int: pull_cart_capacity = 1;          % Guests per pull cart
int: min_guests = 80;                 % Minimum guests to transport
float: max_golf_cart_fraction = 0.60; % At most this fraction of all carts are golf carts

% A safe upper bound on total carts: using only pull carts
int: max_total_carts = min_guests;

% Variables
var 0..max_total_carts: num_golf_carts;  % Number of golf carts used
var 0..max_total_carts: num_pull_carts;  % Number of pull carts used
var 0..max_total_carts: total_carts;     % Total carts used (objective)

% Constraints
% Cart count accounting: total carts equals sum of both types
constraint total_carts = num_golf_carts + num_pull_carts;

% Guest transport requirement: ensure capacity covers at least the minimum guests
constraint golf_cart_capacity * num_golf_carts
         + pull_cart_capacity * num_pull_carts >= min_guests;

% Golf cart fraction limit: at most 60% of all carts are golf carts
% Linearized: num_golf_carts <= 0.60 * total_carts  <=>  10*num_golf_carts <= 6*total_carts
constraint 10 * num_golf_carts <= 6 * total_carts;

% Objective
solve minimize total_carts;