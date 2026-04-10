% Crop planning cost minimization (all data embedded)

int: CAP = 1000;          % maximum total acres
int: FERT_MIN = 800;      % fertility constraint lower bound
int: DEG_MAX = 500;       % degradation constraint upper bound

int: COST_WHEAT = 4;      % $/acre
int: COST_CORN  = 3;      % $/acre

% Decision variables (integer acres)
var 0..CAP: wheat;
var 0..CAP: corn;

% Constraints
constraint wheat + corn <= CAP;
constraint 2*wheat + 4*corn >= FERT_MIN;
constraint 3*wheat - corn <= DEG_MAX;

% Objective: minimize total cost
var 0..(COST_WHEAT*CAP + COST_CORN*CAP): total_cost = COST_WHEAT*wheat + COST_CORN*corn;
solve minimize total_cost;

output [
  "wheat_acres = ", show(wheat), "\n",
  "corn_acres  = ", show(corn), "\n",
  "min_cost    = $", show(total_cost), "\n"
];