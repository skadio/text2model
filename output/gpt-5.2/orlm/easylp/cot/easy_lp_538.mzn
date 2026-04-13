% Parameters (with values embedded)
int: cost_labor = 5;
int: cost_material = 3;
int: cost_equipment = 2;

int: max_budget_expr = 1000;      % 4*labor + material <= 1000
int: min_strength_expr = 500;     % 2*labor + 3*equipment >= 500
int: material_minus_equipment = 100; % material - equipment = 100

% Variables
var 0..1000: labor;        % labor hours (integer, nonnegative)
var 0..1100: material;     % material units (bounded via constraints; safe upper bound)
var 0..1000: equipment;    % equipment units (integer, nonnegative)

var 0..100000: total_cost;

% Constraints
constraint 4 * labor + material <= max_budget_expr;
constraint 2 * labor + 3 * equipment >= min_strength_expr;
constraint material - equipment = material_minus_equipment;

constraint total_cost = cost_labor * labor + cost_material * material + cost_equipment * equipment;

% Objective
solve minimize total_cost;