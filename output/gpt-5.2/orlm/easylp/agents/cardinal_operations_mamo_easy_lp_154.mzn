% Parameters
int: max_total_shipments = 1000;        % Capacity limit: X + Y <= 1000
int: min_transport_units = 1500;        % Demand: 2*X + 3*Y >= 1500
int: min_x_over_y = 200;               % Service: X >= Y + 200
int: units_per_x = 2;                  % Units contributed per shipment on Route X
int: units_per_y = 3;                  % Units contributed per shipment on Route Y
int: cost_per_x = 50;                  % Cost per shipment on Route X ($)
int: cost_per_y = 70;                  % Cost per shipment on Route Y ($)

% Variables
var 0..max_total_shipments: shipX;      % Number of shipments on Route X (integer, non-negative)
var 0..max_total_shipments: shipY;      % Number of shipments on Route Y (integer, non-negative)
var 0..(cost_per_x*max_total_shipments + cost_per_y*max_total_shipments): totalCost; % Total cost ($)

% Constraints
% --- Capacity constraint: total shipments cannot exceed fleet capacity ---
constraint
  shipX + shipY <= max_total_shipments;

% --- Demand/throughput constraint: ensure minimum transported units ---
constraint
  units_per_x * shipX + units_per_y * shipY >= min_transport_units;

% --- Service quality constraint: Route X must exceed Route Y by a margin ---
constraint
  shipX >= shipY + min_x_over_y;

% --- Cost accounting constraint: define total cost consistently ---
constraint
  totalCost = cost_per_x * shipX + cost_per_y * shipY;

% Objective
solve minimize totalCost;