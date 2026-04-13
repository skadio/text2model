% Parameters
% Embedded directly (no .dzn input)
int: max_total_shipments = 1000;           % Capacity limit on total shipments
int: min_balance_lhs = 200;               % Lower bound for 2*X1 - 3*X2
int: max_mix_lhs = 500;                   % Upper bound for 4*X3 - X1

int: cost_x1 = 5;                         % Cost per shipment of type X1
int: cost_x2 = 8;                         % Cost per shipment of type X2
int: cost_x3 = 6;                         % Cost per shipment of type X3

% Variables
var 0..max_total_shipments: x1;           % Number of type X1 shipments
var 0..max_total_shipments: x2;           % Number of type X2 shipments
var 0..max_total_shipments: x3;           % Number of type X3 shipments

% Upper bound: max_total_shipments * max unit cost
var 0..(max_total_shipments * max([cost_x1, cost_x2, cost_x3])): total_cost;

% Constraints
% Capacity constraint: total shipments cannot exceed maximum capacity
constraint x1 + x2 + x3 <= max_total_shipments;

% Balance constraint: maintain service portfolio balance
constraint 2*x1 - 3*x2 >= min_balance_lhs;

% Mix constraint: limit relationship between X3 and X1 shipment counts
constraint 4*x3 - x1 <= max_mix_lhs;

% Total cost definition
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];