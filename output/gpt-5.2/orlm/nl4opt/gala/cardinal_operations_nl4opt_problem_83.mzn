% Mail delivery optimization (all data embedded)

% Parameters
int: runner_capacity = 3;     % bags per runner trip
int: runner_time = 4;         % hours per runner trip
int: canoe_capacity  = 10;    % bags per canoe trip
int: canoe_time  = 2;         % hours per canoe trip
int: max_hours = 200;         % total hours available
int: min_runners = 4;         % at least 4 runner trips
int: canoe_pct_limit = 33;    % at most 33% of deliveries by canoe (per trip)

% Decision variables: number of trips/deliveries by each mode
var 0..(max_hours div runner_time): runners;
var 0..(max_hours div canoe_time): canoes;

% Total hours constraint
constraint runner_time * runners + canoe_time * canoes <= max_hours;

% Minimum runners
constraint runners >= min_runners;

% At most 33% of deliveries (trips) by canoe:
% canoes / (canoes + runners) <= 0.33  <=>  100*canoes <= 33*(canoes + runners)
% Avoid division by cross-multiplying.
constraint 100 * canoes <= canoe_pct_limit * (canoes + runners);

% Objective: maximize total bags delivered
var int: total_bags = runner_capacity * runners + canoe_capacity * canoes;

solve maximize total_bags;

output [
  "runners_trips = ", show(runners), "\n",
  "canoe_trips   = ", show(canoes), "\n",
  "total_hours   = ", show(runner_time*runners + canoe_time*canoes), "\n",
  "total_bags    = ", show(total_bags), "\n"
];