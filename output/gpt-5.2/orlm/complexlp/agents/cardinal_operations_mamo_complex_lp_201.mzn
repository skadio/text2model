% Parameters
% Sets for grains and nutrients
set of int: GRAINS = 1..3;
set of int: NUTRIENTS = 1..4; % 1=A, 2=B, 3=C, 4=D

% Nutrient content per pound for each grain (units per pound)
array[NUTRIENTS, GRAINS] of float: nutrient_per_lb =
  array2d(NUTRIENTS, GRAINS,
    [
      % Grain 1, Grain 2, Grain 3
      20.0,    30.0,    70.0,   % Nutrient A
      10.0,    10.0,     0.0,   % Nutrient B
      50.0,    30.0,     0.0,   % Nutrient C
       6.0,     2.5,    10.0    % Nutrient D
    ]
  );

% Minimum daily requirement for each nutrient (units)
array[NUTRIENTS] of float: min_required = [110.0, 18.0, 90.0, 14.0];

% Cost per pound of each grain (cents per pound)
array[GRAINS] of float: cost_per_lb = [41.0, 36.0, 96.0];


% Variables
% Pounds of each grain fed per day (nonnegative)
array[GRAINS] of var float: lbs_of_grain;

% Total cost in cents (nonnegative)
var float: total_cost;


% Constraints
% Nonnegativity
constraint forall(g in GRAINS) (lbs_of_grain[g] >= 0.0);
constraint total_cost >= 0.0;

% --- Nutrient minimum requirements ---
% For each nutrient n, the total provided by all grains must meet or exceed the minimum required.
constraint
  forall(n in NUTRIENTS) (
    sum(g in GRAINS) (nutrient_per_lb[n, g] * lbs_of_grain[g]) >= min_required[n]
  );

% --- Total cost definition ---
% Total cost equals the sum of (pounds of grain) * (cost per pound) over all grains.
constraint
  total_cost = sum(g in GRAINS) (cost_per_lb[g] * lbs_of_grain[g]);


% Objective
solve minimize total_cost;