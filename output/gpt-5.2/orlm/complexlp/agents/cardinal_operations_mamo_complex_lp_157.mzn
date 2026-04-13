% Parameters
int: num_centers = 6;                 % Number of potential distribution centers
int: num_stores  = 5;                 % Number of retail stores

set of int: CENTERS = 1..num_centers; % Index set for centers
set of int: STORES  = 1..num_stores;  % Index set for stores

array[CENTERS] of int: open_cost =    % Fixed opening cost per center
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS] of int: capacity =     % Supply capacity per center (units)
  [1400, 1115, 813, 1041, 1576, 1364];

array[STORES] of int: demand =        % Demand per store (units)
  [884, 420, 566, 673, 787];

array[CENTERS, STORES] of int: trans_cost = % Transport cost per unit
  [| 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4
   | 3, 4, 4, 1, 3 |];

int: total_demand = sum(s in STORES)(demand[s]); % Total demand (for bounds)


% Variables
array[CENTERS] of var bool: open;               % True if center is opened

array[CENTERS, STORES] of var 0..total_demand: ship; % Units shipped from center c to store s

var int: total_opening_cost;                    % Total fixed opening cost
var int: total_transport_cost;                  % Total variable transport cost
var int: total_cost;                            % Total cost (opening + transport)


% Constraints

% Demand satisfaction: each store's demand must be fully met
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Capacity and opening linkage:
% - shipments out of a center cannot exceed its capacity
% - if a center is closed, it ships nothing (capacity * 0)
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Cost accounting: define opening, transport, and total costs consistently
constraint
  total_opening_cost =
    sum(c in CENTERS)(open_cost[c] * bool2int(open[c]));

constraint
  total_transport_cost =
    sum(c in CENTERS, s in STORES)(trans_cost[c,s] * ship[c,s]);

constraint
  total_cost = total_opening_cost + total_transport_cost;


% Objective
solve minimize total_cost;