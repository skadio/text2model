% Pill mix cost minimization (integer pills)

% Data (embedded)
int: sleep_A = 3;
int: anti_A  = 5;
int: cost_A  = 4;

int: sleep_B = 6;
int: anti_B  = 1;
int: cost_B  = 5;

int: req_sleep = 40;
int: req_anti  = 50;

% Decision variables: number of pills (nonnegative integers)
% Upper bounds are safe and small for this instance
var 0..100: A;
var 0..100: B;

% Nutrient requirements
constraint sleep_A * A + sleep_B * B >= req_sleep;
constraint anti_A  * A + anti_B  * B >= req_anti;

% Objective: minimize total cost
var int: total_cost = cost_A * A + cost_B * B;

solve minimize total_cost;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "total_cost = ", show(total_cost), "\n",
  "sleep_units = ", show(sleep_A*A + sleep_B*B), "\n",
  "anti_units = ", show(anti_A*A + anti_B*B), "\n"
];