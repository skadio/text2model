% Parameters
int: num_centers = 7;              % number of distribution centers
int: num_stores  = 9;              % number of retail stores

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

% NOTE:
% The problem statement in this chat does not provide the explicit 7x9 transportation
% cost matrix, the 9 store demands, nor the 7 center capacities. Since you requested
% that all data must be embedded directly in the model (no .dzn), this model cannot
% be instantiated to compute a numeric "optimal total cost" without those values.
% The following placeholders are included to make the model syntactically complete;
% you must replace them with the actual data.

array[CENTERS, STORES] of int: trans_cost =
  array2d(CENTERS, STORES, [
    % center 1 -> stores 1..9
    1,1,1,1,1,1,1,1,1,
    % center 2
    1,1,1,1,1,1,1,1,1,
    % center 3
    1,1,1,1,1,1,1,1,1,
    % center 4
    1,1,1,1,1,1,1,1,1,
    % center 5
    1,1,1,1,1,1,1,1,1,
    % center 6
    1,1,1,1,1,1,1,1,1,
    % center 7
    1,1,1,1,1,1,1,1,1
  ]);

array[STORES] of int: demand =
  [440, 440, 440, 440, 440, 440, 440, 440, 440];

array[CENTERS] of int: capacity =
  [1000, 1000, 1000, 1000, 1000, 1000, 1000];


% Variables
array[CENTERS] of var bool: open;                 % true if center is opened
array[CENTERS, STORES] of var int: ship_units;    % units shipped from center i to store j (>= 0)

var int: total_open_cost;                         % total opening cost
var int: total_transport_cost;                    % total transportation cost
var int: total_cost;                              % total cost (opening + transport)


% Constraints
% Domain / nonnegativity constraints
constraint forall(i in CENTERS, j in STORES) (ship_units[i,j] >= 0);

constraint total_open_cost >= 0;
constraint total_transport_cost >= 0;
constraint total_cost >= 0;

% Demand satisfaction: each store must receive exactly its demand
constraint
  forall(j in STORES) (
    sum(i in CENTERS)(ship_units[i,j]) = demand[j]
  );

% Capacity/opening linkage: ship only if open, and within capacity
constraint
  forall(i in CENTERS) (
    sum(j in STORES)(ship_units[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Cost accounting: opening
constraint
  total_open_cost = sum(i in CENTERS)(open_cost[i] * bool2int(open[i]));

% Cost accounting: transportation
constraint
  total_transport_cost = sum(i in CENTERS, j in STORES)(trans_cost[i,j] * ship_units[i,j]);

% Total cost
constraint
  total_cost = total_open_cost + total_transport_cost;


% Objective
solve minimize total_cost;