% Parameters
% Profit per kg (£/kg)
int: profit_A = 30;
int: profit_B = 10;

% Available production time (hours per week)
int: max_hours = 40;

% Production time required per kg (hours/kg)
int: hours_per_kg_A = 6;
int: hours_per_kg_B = 3;

% Market demand ratio: B must be at least this multiple of A
int: ratio_B_to_A = 3;

% Storage constraint: at most this many kg of A can be stored per week
int: max_storage_A = 4;

% Variables
% Weekly production quantities (kg)
var 0..max_storage_A: kg_A;                         % bounded by storage limit on A
var 0..(max_hours div hours_per_kg_B): kg_B;        % upper bound if all hours go to B

% Total weekly profit (£)
var 0..(profit_A * max_storage_A
       + profit_B * (max_hours div hours_per_kg_B)): total_profit;

% Constraints
% Production time capacity
constraint
  hours_per_kg_A * kg_A + hours_per_kg_B * kg_B <= max_hours;

% Market demand requirement: B >= 3 * A
constraint
  kg_B >= ratio_B_to_A * kg_A;

% Profit definition
constraint
  total_profit = profit_A * kg_A + profit_B * kg_B;

% Objective
solve maximize total_profit;