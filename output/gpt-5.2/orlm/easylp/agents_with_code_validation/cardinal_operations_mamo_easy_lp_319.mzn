% Parameters
% Problem constants (embedded directly, no external data files)
int: max_total_shipments = 1000;          % Capacity limit on total shipments
int: min_balance_lhs = 200;               % Minimum required value for (2*X1 - 3*X2)
int: max_service_lhs = 500;               % Maximum allowed value for (4*X3 - X1)

int: cost_x1 = 5;                         % Cost per type X1 shipment
int: cost_x2 = 8;                         % Cost per type X2 shipment
int: cost_x3 = 6;                         % Cost per type X3 shipment

% Variables
% Decision variables: number of shipments of each type (non-negative integers)
var 0..max_total_shipments: x1;
var 0..max_total_shipments: x2;
var 0..max_total_shipments: x3;

% Total cost variable (upper bound: worst-case per-shipment cost sum times max shipments)
var 0..(cost_x1 + cost_x2 + cost_x3) * max_total_shipments: total_cost;

% Constraints
% Capacity constraint: total shipments across all types cannot exceed the limit
constraint x1 + x2 + x3 <= max_total_shipments;

% Portfolio balance constraint: ensure minimum service balance level
constraint 2 * x1 - 3 * x2 >= min_balance_lhs;

% Service mix constraint: limit on (4*X3 - X1)
constraint 4 * x3 - x1 <= max_service_lhs;

% Total cost definition: link total_cost to shipment decisions
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;