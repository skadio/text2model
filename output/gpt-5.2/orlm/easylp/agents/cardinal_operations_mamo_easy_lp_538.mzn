% Parameters
% Unit costs
int: cost_labor = 5;        % cost per labor hour
int: cost_material = 3;     % cost per unit of material
int: cost_equipment = 2;    % cost per unit of equipment

% Constraint coefficients / RHS
int: max_4labor_plus_material = 1000;  % 4*labor + material <= 1000
int: min_2labor_plus_3equip = 500;     % 2*labor + 3*equipment >= 500
int: material_minus_equipment = 100;   % material - equipment == 100

% Variables
var 0..1000: labor;        % labor hours (nonnegative integer)
var 0..1000: material;     % material units (nonnegative integer)
var 0..1000: equipment;    % equipment units (nonnegative integer)

var 0..10000: total_cost;  % total cost (bounded for safety; linear expression)

% Constraints
% Total cost definition (linear expression)
constraint
  total_cost = cost_labor * labor + cost_material * material + cost_equipment * equipment;

% Budget/limit constraint: 4*labor + material <= 1000
constraint
  4 * labor + material <= max_4labor_plus_material;

% Minimum strength/requirement constraint: 2*labor + 3*equipment >= 500
constraint
  2 * labor + 3 * equipment >= min_2labor_plus_3equip;

% Exact difference constraint: material - equipment == 100
constraint
  material - equipment = material_minus_equipment;

% Objective
solve minimize total_cost;