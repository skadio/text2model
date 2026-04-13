% Parameters
int: cost_raw = 4;              % Cost per unit of raw materials
int: cost_labor = 3;            % Cost per unit of labor
int: cost_transport = 2;        % Cost per unit of transportation

int: min_raw_plus_labor = 50;        % Minimum required combined raw + labor
int: max_labor_minus_transport = 10; % Maximum allowed (labor - transport)
int: raw_minus_labor_eq = 20;        % Exact required excess of raw over labor
int: max_raw_plus_transport = 100;   % Maximum allowed combined raw + transport

% Variables
var 0..100: raw;                     % Units of raw materials procured (integer, non-negative)
var 0..100: labor;                   % Units of labor deployed (integer, non-negative)
var 0..100: transport;               % Units of transportation (integer, non-negative)

var 0..(cost_raw*100 + cost_labor*100 + cost_transport*100): total_cost; % Total cost (bounded)

% Constraints
% Link total_cost to the resource allocation decisions
constraint
  total_cost = cost_raw * raw + cost_labor * labor + cost_transport * transport;

% Ensure minimum combined raw materials and labor
constraint
  raw + labor >= min_raw_plus_labor;

% Limit the difference between labor and transportation (does not exceed 10)
constraint
  labor - transport <= max_labor_minus_transport;

% Enforce exact excess of raw materials over labor
constraint
  raw - labor = raw_minus_labor_eq;

% Storage limitation: combined raw materials and transportation cannot exceed capacity
constraint
  raw + transport <= max_raw_plus_transport;

% Objective
solve minimize total_cost;