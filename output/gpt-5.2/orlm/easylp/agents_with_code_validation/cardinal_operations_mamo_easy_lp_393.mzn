% Parameters
% Per-unit costs (in dollars)
int: cost_T = 500; % Technology
int: cost_P = 300; % Physics
int: cost_S = 200; % Sports
int: cost_R = 100; % Research

% Policy upper bounds on combined allocations (in units)
int: max_TP = 50;  % Technology + Physics
int: max_SR = 30;  % Sports + Research

% Minimum required allocations (in units)
int: min_T = 15;
int: min_P = 10;
int: min_S = 5;
int: min_R = 2;

% Variables
% Integer units allocated to each department
var min_T..max_TP: units_T;
var min_P..max_TP: units_P;
var min_S..max_SR: units_S;
var min_R..max_SR: units_R;

% Total cost (in dollars)
var int: total_cost;

% Constraints
% Department minimum allocation requirements (redundant with variable domains, kept for clarity)
constraint units_T >= min_T;
constraint units_P >= min_P;
constraint units_S >= min_S;
constraint units_R >= min_R;

% Combined upper bounds due to policy limits
constraint units_T + units_P <= max_TP;
constraint units_S + units_R <= max_SR;

% Define total cost from per-unit costs and allocated units
constraint total_cost =
  cost_T * units_T + cost_P * units_P + cost_S * units_S + cost_R * units_R;

% Objective
solve minimize total_cost;

output [
  "units_T=", show(units_T), "\n",
  "units_P=", show(units_P), "\n",
  "units_S=", show(units_S), "\n",
  "units_R=", show(units_R), "\n",
  "total_cost=", show(total_cost), "\n"
];