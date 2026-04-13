% Parameters
int: max_total_shipments = 1000;          % Capacity limit for total shipments X+Y
int: min_units = 1500;                   % Minimum required transported units
int: units_per_x = 2;                    % Units contribution per shipment on Route X
int: units_per_y = 3;                    % Units contribution per shipment on Route Y
int: min_x_minus_y = 200;                % Service quality requirement: X >= Y + 200
int: cost_per_x = 50;                    % Cost per shipment on Route X (dollars)
int: cost_per_y = 70;                    % Cost per shipment on Route Y (dollars)

% Variables
var 0..max_total_shipments: x_shipments;  % Number of shipments on Route X (integer)
var 0..max_total_shipments: y_shipments;  % Number of shipments on Route Y (integer)
var 0..(cost_per_x*max_total_shipments + cost_per_y*max_total_shipments): total_cost;
                                          % Total cost (dollars), bounded upper estimate

% Constraints
% Capacity constraint: total shipments across both routes must not exceed limit
constraint x_shipments + y_shipments <= max_total_shipments;

% Demand constraint: transported units must meet or exceed the minimum requirement
constraint units_per_x * x_shipments + units_per_y * y_shipments >= min_units;

% Service quality constraint: Route X shipments must be at least min_x_minus_y more than Route Y
constraint x_shipments - y_shipments >= min_x_minus_y;

% Cost definition constraint: total_cost equals sum of per-route shipment costs
constraint total_cost = cost_per_x * x_shipments + cost_per_y * y_shipments;

% Objective
solve minimize total_cost;