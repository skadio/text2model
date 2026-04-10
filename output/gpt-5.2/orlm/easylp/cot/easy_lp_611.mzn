% Parameters (with values embedded)
int: max_wheat_corn = 500;
int: max_rice_barley = 600;

int: wheat_minus_rice_min = 100;
int: corn_minus_barley_min = 200;

int: cost_wheat = 10;
int: cost_corn = 20;
int: cost_rice = 30;
int: cost_barley = 40;

% Note: The description mentions "each crop has specific bounds on land allocation"
% but no numeric per-crop bounds are provided. We therefore use non-negativity
% and derive safe upper bounds from the given combined-area limits.
int: ub_wheat = max_wheat_corn;
int: ub_corn  = max_wheat_corn;
int: ub_rice  = max_rice_barley;
int: ub_barley= max_rice_barley;

% Variables
var 0..ub_wheat: Wheat;
var 0..ub_corn: Corn;
var 0..ub_rice: Rice;
var 0..ub_barley: Barley;

var 0..(cost_wheat*ub_wheat + cost_corn*ub_corn + cost_rice*ub_rice + cost_barley*ub_barley): TotalCost;

% Constraints
constraint Wheat + Corn <= max_wheat_corn;
constraint Rice + Barley <= max_rice_barley;

constraint Wheat >= Rice + wheat_minus_rice_min;
constraint Corn  >= Barley + corn_minus_barley_min;

constraint TotalCost =
  cost_wheat * Wheat +
  cost_corn  * Corn  +
  cost_rice  * Rice  +
  cost_barley* Barley;

% Objective
solve minimize TotalCost;