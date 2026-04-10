% Parameters
int: num_centers = 5;              % number of potential distribution centers
int: num_stores  = 9;              % number of retail stores

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =  % fixed opening cost per center ($)
  [151000, 192000, 114000, 171000, 160000];

array[CENTERS] of int: capacity =   % supply capacity per center (units)
  [1825, 1821, 1365, 1929, 1502];

array[STORES] of int: demand =      % demand per store (units)
  [739, 491, 834, 721, 681, 662, 612, 521, 480];

% Transportation cost per unit from center i to store j ($/unit)
array[CENTERS, STORES] of int: trans_cost =
  array2d(CENTERS, STORES,
  [
    % Store:   1  2  3  4  5  6  7  8  9
              5, 2, 3, 4, 6, 7, 3, 6, 5,   % Center 1
              2, 4, 6, 3, 5, 4, 7, 3, 5,   % Center 2
              4, 3, 5, 6, 2, 5, 4, 6, 3,   % Center 3
              6, 5, 4, 2, 4, 3, 5, 2, 4,   % Center 4
              3, 6, 2, 5, 3, 6, 2, 4, 3    % Center 5
  ]);

% Variables
array[CENTERS] of var bool: open;                    % true if center is opened
array[CENTERS, STORES] of var 0..max(demand): ship;  % units shipped from center i to store j

var int: total_open_cost;                            % total fixed opening cost ($)
var int: total_trans_cost;                           % total transportation cost ($)
var int: total_cost;                                 % total cost ($)

% Constraints

% Link total opening cost to which centers are opened
constraint
  total_open_cost = sum(c in CENTERS)(open_cost[c] * bool2int(open[c]));

% Link total transportation cost to shipped quantities and per-unit costs
constraint
  total_trans_cost = sum(c in CENTERS, s in STORES)(trans_cost[c, s] * ship[c, s]);

% Total cost is the sum of fixed opening cost and transportation cost
constraint
  total_cost = total_open_cost + total_trans_cost;

% Demand satisfaction: each store's total received shipment must meet its demand exactly
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c, s]) = demand[s]
  );

% Capacity and opening linkage:
% - total shipped out of a center cannot exceed its capacity
% - if a center is closed, it must ship nothing
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

% Objective
solve minimize total_cost;