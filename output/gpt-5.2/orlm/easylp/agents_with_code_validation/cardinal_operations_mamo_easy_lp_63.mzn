% Parameters
int: max_total_bandwidth = 10000;          % Maximum total bandwidth available (Mbps)
int: min_effectiveness = 5000;            % Minimum required effectiveness score (points)

int: eff_per_mbps_X = 2;                  % Effectiveness contribution per Mbps of service X
int: eff_per_mbps_Y = 3;                  % Effectiveness contribution per Mbps of service Y

float: cost_per_mbps_X = 0.2;             % Cost per Mbps of service X ($/Mbps)
float: cost_per_mbps_Y = 0.3;             % Cost per Mbps of service Y ($/Mbps)

% Variables
var 0..max_total_bandwidth: bandwidth_X;  % Allocated bandwidth to service X (Mbps, integer)
var 0..max_total_bandwidth: bandwidth_Y;  % Allocated bandwidth to service Y (Mbps, integer)

var 0.0..(cost_per_mbps_X * max_total_bandwidth + cost_per_mbps_Y * max_total_bandwidth): total_cost;
                                          % Total cost in dollars ($)

% Constraints
% --- Bandwidth capacity constraint ---
% Total allocated bandwidth across both services must not exceed available capacity.
constraint
  bandwidth_X + bandwidth_Y <= max_total_bandwidth;

% --- Minimum effectiveness requirement ---
% Ensure the combined effectiveness score meets or exceeds the minimum required.
constraint
  eff_per_mbps_X * bandwidth_X + eff_per_mbps_Y * bandwidth_Y >= min_effectiveness;

% --- Total cost definition ---
% Link total_cost to the chosen bandwidth allocations.
constraint
  total_cost = cost_per_mbps_X * int2float(bandwidth_X)
             + cost_per_mbps_Y * int2float(bandwidth_Y);

% Objective
solve minimize total_cost;