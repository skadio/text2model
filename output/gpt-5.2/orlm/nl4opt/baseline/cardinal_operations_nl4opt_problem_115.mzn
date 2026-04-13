% Teddy bear production (LP) - minimize cost

% Decision variables: hours to run each factory (continuous, nonnegative)
var float: h1 >= 0.0; % factory 1 hours
var float: h2 >= 0.0; % factory 2 hours

% Production per hour
float: b1 = 5.0;  float: w1 = 6.0;  float: br1 = 3.0;  % factory 1
float: b2 = 10.0; float: w2 = 10.0; float: br2 = 0.0;  % factory 2

% Demand requirements (at least)
float: req_black = 20.0;
float: req_white = 5.0;
float: req_brown = 15.0;

% Costs per hour
float: c1 = 300.0;
float: c2 = 600.0;

% Constraints: meet demands
constraint b1*h1 + b2*h2 >= req_black;
constraint w1*h1 + w2*h2 >= req_white;
constraint br1*h1 + br2*h2 >= req_brown;

% Objective: minimize total cost
var float: total_cost = c1*h1 + c2*h2;

solve minimize total_cost;

output [
  "Factory1_hours = ", show(h1), "\n",
  "Factory2_hours = ", show(h2), "\n",
  "Total_cost = ", show(total_cost), "\n",
  "Black_produced = ", show(b1*h1 + b2*h2), "\n",
  "White_produced = ", show(w1*h1 + w2*h2), "\n",
  "Brown_produced = ", show(br1*h1 + br2*h2), "\n"
];