% Parameters
% Unit costs
int: cost_raw = 4;
int: cost_labor = 3;
int: cost_transport = 2;

% Constraint constants
int: min_raw_plus_labor = 50;          % raw + labor >= 50
int: max_labor_minus_transport = 10;   % labor - transport <= 10
int: raw_minus_labor_eq = 20;          % raw - labor = 20
int: max_raw_plus_transport = 100;     % raw + transport <= 100

% Variables
var 0..1000: raw_materials;     % units of raw materials procured (integer, non-negative)
var 0..1000: labor_units;       % units of labor deployed (integer, non-negative)
var 0..1000: transport_units;   % units of transportation (integer, non-negative)

var 0..1000000: total_cost;     % total cost (linear expression, bounded)

% Constraints
% Link total cost to decision variables (linear cost calculation)
constraint
  total_cost = cost_raw * raw_materials
             + cost_labor * labor_units
             + cost_transport * transport_units;

% Minimum combined raw materials and labor requirement
constraint
  raw_materials + labor_units >= min_raw_plus_labor;

% Labor vs transportation difference limit (as stated: labor - transport <= 10)
constraint
  labor_units - transport_units <= max_labor_minus_transport;

% Exact excess of raw materials over labor
constraint
  raw_materials - labor_units = raw_minus_labor_eq;

% Storage limitation: combined raw materials and transportation upper bound
constraint
  raw_materials + transport_units <= max_raw_plus_transport;

% Objective
solve minimize total_cost;