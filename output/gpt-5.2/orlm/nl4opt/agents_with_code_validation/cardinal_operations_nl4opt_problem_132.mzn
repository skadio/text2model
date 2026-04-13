% Parameters
% Resource usage (minutes per unit)
int: assembly_per_desk   = 40;
int: sanding_per_desk    = 20;
int: assembly_per_drawer = 30;
int: sanding_per_drawer  = 10;

% Available capacity (minutes)
int: assembly_available = 4000;
int: sanding_available  = 3500;

% Profit per unit ($)
int: profit_per_desk   = 100;
int: profit_per_drawer = 90;


% Variables
% Decision variables: number of units to produce (non-negative integers)
var 0..(assembly_available div assembly_per_desk): desks;
var 0..(assembly_available div assembly_per_drawer): drawers;

% Total profit (upper bound based on best profit per assembly minute usage)
var 0..(max(profit_per_desk, profit_per_drawer) * assembly_available): total_profit;


% Constraints
% --- Capacity constraints: do not exceed available minutes ---
constraint
  assembly_per_desk * desks + assembly_per_drawer * drawers
  <= assembly_available;

constraint
  sanding_per_desk * desks + sanding_per_drawer * drawers
  <= sanding_available;

% --- Profit definition: compute total profit from production quantities ---
constraint
  total_profit = profit_per_desk * desks + profit_per_drawer * drawers;


% Objective
solve maximize total_profit;