% Crop planning (all data embedded)

% Costs ($ per acre)
int: cost_wheat = 20;
int: cost_corn  = 30;
int: cost_soy   = 10;

% Decision variables: whole acres
var 0..200: wheat;
var 0..200: corn;
var 0..200: soy;

% Constraints
constraint wheat + corn <= 200;                 % space limit
constraint 2 * wheat + soy >= 150;              % rotation constraint
constraint abs(corn - soy) <= 100;              % difference limit

% Objective: minimize total cost
var int: total_cost = cost_wheat * wheat + cost_corn * corn + cost_soy * soy;

solve minimize total_cost;

output [
  "wheat_acres = ", show(wheat), "\n",
  "corn_acres  = ", show(corn),  "\n",
  "soy_acres   = ", show(soy),   "\n",
  "total_cost  = $", show(total_cost), "\n"
];