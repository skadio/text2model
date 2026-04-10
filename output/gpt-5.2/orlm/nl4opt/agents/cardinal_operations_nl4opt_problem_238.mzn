% Parameters
% Profit per unit
int: profit_phone  = 120;
int: profit_laptop = 40;

% Floor space requirement (sq ft per unit)
int: space_phone   = 1;
int: space_laptop  = 4;

% Total available floor space (sq ft)
int: total_space   = 400;

% Minimum fraction of inventory that must be laptops (80%)
int: min_laptop_pct = 80;   % use percent to avoid floats
int: pct_base       = 100;

% Cost to the store per unit ($)
int: cost_phone   = 400;
int: cost_laptop  = 100;

% Total budget available ($)
int: max_budget   = 6000;


% Variables
% Decision variables: number of phones and laptops to stock (nonnegative integers)
var 0..400: phones;    % upper bound from space (1 sq ft each, 400 sq ft total)
var 0..100: laptops;   % upper bound from space (4 sq ft each, 400 sq ft total)


% Constraints

% Floor space capacity constraint
% Total space used by phones and laptops must not exceed available space.
constraint
  space_phone * phones + space_laptop * laptops <= total_space;

% Budget constraint
% Total purchasing cost must not exceed the available budget.
constraint
  cost_phone * phones + cost_laptop * laptops <= max_budget;

% Minimum laptop percentage constraint (at least 80% of total inventory)
% Avoid floats by cross-multiplying with pct_base:
% laptops / (phones + laptops) >= min_laptop_pct / pct_base
% => pct_base*laptops >= min_laptop_pct*(phones + laptops)
constraint
  pct_base * laptops >= min_laptop_pct * (phones + laptops);


% Objective
solve maximize profit_phone * phones + profit_laptop * laptops;