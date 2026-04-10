% Parameters
int: max_total_bandwidth = 10000;          % Maximum total bandwidth available (Mbps)
int: min_effectiveness = 5000;            % Minimum required effectiveness score (points)

int: eff_per_mbps_X = 2;                  % Effectiveness points per Mbps of service X
int: eff_per_mbps_Y = 3;                  % Effectiveness points per Mbps of service Y

% Costs in dollars per Mbps (given as 0.2 and 0.3); use cents to keep integer objective
int: cost_cents_per_mbps_X = 20;          % 0.2 dollars = 20 cents per Mbps
int: cost_cents_per_mbps_Y = 30;          % 0.3 dollars = 30 cents per Mbps


% Variables
var 0..max_total_bandwidth: bw_X;         % Bandwidth allocated to service X (Mbps, integer)
var 0..max_total_bandwidth: bw_Y;         % Bandwidth allocated to service Y (Mbps, integer)

var 0..(cost_cents_per_mbps_X*max_total_bandwidth
      + cost_cents_per_mbps_Y*max_total_bandwidth): total_cost_cents;  % Total cost (cents)

% (Optional) total cost in dollars as a float view
var float: total_cost_dollars;            % Total cost (dollars)


% Constraints

% Bandwidth capacity constraint: total allocated bandwidth cannot exceed available maximum
constraint
  bw_X + bw_Y <= max_total_bandwidth;

% Minimum effectiveness constraint: ensure required service effectiveness is met
constraint
  eff_per_mbps_X * bw_X + eff_per_mbps_Y * bw_Y >= min_effectiveness;

% Total cost definition (in cents): linear cost based on allocated bandwidth
constraint
  total_cost_cents =
    cost_cents_per_mbps_X * bw_X + cost_cents_per_mbps_Y * bw_Y;

% Dollar-view linkage: convert cents to dollars as a float (view constraint)
constraint
  total_cost_dollars = total_cost_cents / 100.0;


% Objective
solve minimize total_cost_cents;