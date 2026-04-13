% Parameters (with values embedded)
int: cost_raw = 5;
int: cost_labor = 4;
int: cost_trans = 6;

int: min_diff_raw_vs_2labor = 500;
int: max_labor_plus_trans = 1000;
int: raw_minus_trans = 200;

% Variables
var int: raw;
var int: labor;
var int: trans;

var int: total_cost;

% Constraints
constraint raw - 2 * labor >= min_diff_raw_vs_2labor;
constraint labor + trans <= max_labor_plus_trans;
constraint raw = trans + raw_minus_trans;

% Non-negativity (implicit in the real-world context)
constraint raw >= 0;
constraint labor >= 0;
constraint trans >= 0;

% Define objective expression
constraint total_cost = cost_raw * raw + cost_labor * labor + cost_trans * trans;

% Objective
solve minimize total_cost;