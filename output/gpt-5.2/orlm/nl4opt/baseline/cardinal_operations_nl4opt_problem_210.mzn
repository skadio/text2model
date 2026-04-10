% LP: minimize cost of pills A and B subject to medicine requirements

% Data (embedded)
int: sleep_A = 3;
int: anti_A  = 5;
int: sleep_B = 6;
int: anti_B  = 1;

int: cost_A = 4;
int: cost_B = 5;

int: req_sleep = 40;
int: req_anti  = 50;

% Decision variables: number of pills (nonnegative, continuous)
var 0.0..1.0e6: xA;
var 0.0..1.0e6: xB;

% Objective: minimize total cost
var float: total_cost = cost_A * xA + cost_B * xB;

constraint sleep_A * xA + sleep_B * xB >= req_sleep;
constraint anti_A  * xA + anti_B  * xB >= req_anti;

solve minimize total_cost;

output [
  "Pills A = ", show(xA), "\n",
  "Pills B = ", show(xB), "\n",
  "Total cost = $", show(total_cost), "\n"
];