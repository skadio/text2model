% Parameters
int: num_centers = 4;                % Number of potential distribution centers
int: num_outlets = 4;                % Number of retail outlets

set of int: CENTERS = 1..num_centers;
set of int: OUTLETS = 1..num_outlets;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000];  % Fixed opening cost per center ($)
array[CENTERS] of int: capacity  = [1547,   1656,   1274,   1882];    % Supply capacity per center (units)
array[OUTLETS] of int: demand    = [859,    713,    421,    652];     % Demand per outlet (units)

array[CENTERS, OUTLETS] of int: transport_cost =  % Unit transport costs ($/unit)
[
  % outlets:   1  2  3  4
              5, 5, 2, 3,   % center 1
              3, 3, 5, 4,   % center 2
              3, 5, 2, 4,   % center 3
              2, 4, 5, 1    % center 4
];

int: total_demand = sum(o in OUTLETS)(demand[o]);  % Upper bound helper for flows

% Variables
array[CENTERS] of var 0..1: open;  % 1 if center is opened, 0 otherwise

array[CENTERS, OUTLETS] of var 0..total_demand: ship; % Units shipped from center c to outlet o

var int: total_cost;  % Total cost = opening + transportation

% Constraints

% Demand fulfillment: each outlet's incoming shipments must meet its demand exactly
constraint
  forall(o in OUTLETS) (
    sum(c in CENTERS)(ship[c,o]) = demand[o]
  );

% Capacity / opening linkage: shipments from a center cannot exceed its capacity if opened
constraint
  forall(c in CENTERS) (
    sum(o in OUTLETS)(ship[c,o]) <= capacity[c] * open[c]
  );

% Total cost definition: fixed opening costs + per-unit transport costs
constraint
  total_cost =
    sum(c in CENTERS)(open_cost[c] * open[c]) +
    sum(c in CENTERS, o in OUTLETS)(transport_cost[c,o] * ship[c,o]);

% Objective
solve minimize total_cost;