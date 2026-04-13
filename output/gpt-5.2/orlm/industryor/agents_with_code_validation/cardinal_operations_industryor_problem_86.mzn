% Parameters
% Demand (cubic meters)
int: demand_refrigerated = 3000;
int: demand_nonrefrigerated = 4000;

% Truck capacities (cubic meters)
int: capA_refrigerated = 20;
int: capA_nonrefrigerated = 40;

% Type B has equal refrigerated/non-refrigerated capacity and same total as Type A
int: cap_total = capA_refrigerated + capA_nonrefrigerated;      % 60
int: capB_refrigerated = cap_total div 2;                       % 30
int: capB_nonrefrigerated = cap_total div 2;                    % 30

% Costs (per kilometer)
int: costA_per_km = 30;
int: costB_per_km = 40;

% Upper bounds (safe bounds derived from demands)
int: maxA = max( (demand_refrigerated + capA_refrigerated - 1) div capA_refrigerated,
                 (demand_nonrefrigerated + capA_nonrefrigerated - 1) div capA_nonrefrigerated );
int: maxB = max( (demand_refrigerated + capB_refrigerated - 1) div capB_refrigerated,
                 (demand_nonrefrigerated + capB_nonrefrigerated - 1) div capB_nonrefrigerated );

% Variables
var 0..maxA: numA;  % number of Type A trucks rented
var 0..maxB: numB;  % number of Type B trucks rented

var 0..(costA_per_km*maxA + costB_per_km*maxB): total_cost_per_km; % total cost per km


% Constraints
% Satisfy refrigerated cargo demand
constraint
  capA_refrigerated * numA + capB_refrigerated * numB >= demand_refrigerated;

% Satisfy non-refrigerated cargo demand
constraint
  capA_nonrefrigerated * numA + capB_nonrefrigerated * numB >= demand_nonrefrigerated;

% Define total rental cost per kilometer (linear cost aggregation)
constraint
  total_cost_per_km = costA_per_km * numA + costB_per_km * numB;


% Objective
solve minimize total_cost_per_km;