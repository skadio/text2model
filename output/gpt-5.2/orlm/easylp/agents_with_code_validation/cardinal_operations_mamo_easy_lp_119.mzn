% Parameters
int: max_total_trips = 50;              % Resource limit on total number of trips
int: min_weighted_trips = 30;           % Minimum required value of 2*X + 3*Y
int: weight_x = 2;                      % Weight coefficient for trip X in balance constraint
int: weight_y = 3;                      % Weight coefficient for trip Y in balance constraint
int: cost_x = 100;                      % Investment cost per trip X (in dollars)
int: cost_y = 200;                      % Investment cost per trip Y (in dollars)

% Variables
var 0..max_total_trips: trips_x;         % Number of trip X (integer, nonnegative, bounded)
var 0..max_total_trips: trips_y;         % Number of trip Y (integer, nonnegative, bounded)
var 0..(cost_x*max_total_trips + cost_y*max_total_trips): total_investment;
                                        % Total investment (bounded linear expression)

% Constraints
% Total trips capacity constraint (resource limit)
constraint
  trips_x + trips_y <= max_total_trips;

% Weighted balance/coverage constraint (2*X + 3*Y must reach minimum)
constraint
  weight_x * trips_x + weight_y * trips_y >= min_weighted_trips;

% Define total investment as the linear cost of chosen trips
constraint
  total_investment = cost_x * trips_x + cost_y * trips_y;

% Objective
solve minimize total_investment;