% Parameters (with values embedded)
int: cost_wheat = 5;
int: cost_corn = 4;
int: cost_soy = 6;

int: max_c1 = 50; % 2*wheat + corn <= 50
int: max_c2 = 60; % wheat + 3*soy <= 60
int: min_c3 = 30; % corn + soy >= 30

% Variables
var 0..30: wheat;   % from 2*wheat + corn <= 50 and corn >= 0
var 0..50: corn;    % from 2*wheat + corn <= 50
var 0..20: soy;     % from wheat + 3*soy <= 60 and wheat >= 0

var 0..100000: total_cost;

% Constraints
constraint 2 * wheat + corn <= max_c1;
constraint wheat + 3 * soy <= max_c2;
constraint corn + soy >= min_c3;

constraint total_cost = cost_wheat * wheat + cost_corn * corn + cost_soy * soy;

% Objective
solve minimize total_cost;

output [
  "wheat=", show(wheat), "\n",
  "corn=", show(corn), "\n",
  "soy=", show(soy), "\n",
  "total_cost=", show(total_cost), "\n"
];