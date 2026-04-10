% Parameters
% Minimum weekly demand (sq ft)
int: min_hardwood_demand = 20000;
int: min_vinyl_demand    = 10000;

% Minimum total shipment requirement (sq ft)
int: min_total_shipment  = 60000;

% Maximum weekly production capacity (sq ft)
int: max_hardwood_prod   = 50000;
int: max_vinyl_prod      = 30000;

% Profit per square foot ($)
float: profit_hardwood   = 2.5;
float: profit_vinyl      = 3.0;

% Variables
% Weekly production quantities (sq ft)
var 0..max_hardwood_prod: hardwood_sqft; % hardwood produced
var 0..max_vinyl_prod:    vinyl_sqft;    % vinyl produced

% Constraints
% Demand satisfaction constraints (meet minimum forecast demand)
constraint hardwood_sqft >= min_hardwood_demand;
constraint vinyl_sqft    >= min_vinyl_demand;

% Total shipment requirement (ship at least the contracted minimum total sqft)
constraint hardwood_sqft + vinyl_sqft >= min_total_shipment;

% Production capacity constraints (explicit maximum weekly limits)
constraint hardwood_sqft <= max_hardwood_prod;
constraint vinyl_sqft    <= max_vinyl_prod;

% Objective
solve maximize profit_hardwood * hardwood_sqft + profit_vinyl * vinyl_sqft;