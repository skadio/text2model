% Parameters
int: max_bandwidth = 10000;
int: min_effectiveness = 5000;
int: eff_x = 2;
int: eff_y = 3;

% Scale costs to cents to keep integrality
int: cost_x_cents_per_mbps = 20;  % $0.20 = 20 cents
int: cost_y_cents_per_mbps = 30;  % $0.30 = 30 cents

% Variables
var 0..max_bandwidth: x;  % Mbps for service X (integer)
var 0..max_bandwidth: y;  % Mbps for service Y (integer)
var 0..(cost_x_cents_per_mbps * max_bandwidth + cost_y_cents_per_mbps * max_bandwidth): total_cost_cents;

% Constraints
constraint x + y <= max_bandwidth;
constraint eff_x * x + eff_y * y >= min_effectiveness;
constraint total_cost_cents = cost_x_cents_per_mbps * x + cost_y_cents_per_mbps * y;

% Objective
solve minimize total_cost_cents;