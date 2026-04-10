include "globals.mzn";

% Data (embedded)
int: golf_capacity = 4;          % guests per golf cart
int: pull_capacity = 1;          % guests per pull cart
float: max_golf_fraction = 0.60; % at most 60% of carts are golf carts
int: min_guests = 80;

% Decision variables
var 0..min_guests: golf;  % number of golf carts
var 0..min_guests: pull;  % number of pull carts
var 0..2*min_guests: total_carts = golf + pull;

% Must transport at least min_guests guests
constraint golf_capacity * golf + pull_capacity * pull >= min_guests;

% At most 60% of carts are golf carts:
% golf / (golf + pull) <= 0.6  <=>  10*golf <= 6*(golf + pull)  <=>  4*golf <= 6*pull
constraint 4 * golf <= 6 * pull;

% Objective: minimize total number of carts
solve minimize total_carts;

output [
  "golf_carts = ", show(golf), "\n",
  "pull_carts = ", show(pull), "\n",
  "total_carts = ", show(total_carts), "\n",
  "guests_capacity = ", show(golf_capacity * golf + pull_capacity * pull), "\n"
];