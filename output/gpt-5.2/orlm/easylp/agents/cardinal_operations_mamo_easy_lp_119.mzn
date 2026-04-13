% Parameters
int: max_total_trips = 50;          % Maximum total number of trips (X + Y)
int: min_weighted_trips = 30;       % Minimum required value of (2*X + 3*Y)
int: weight_x = 2;                  % Weight coefficient for trip type X
int: weight_y = 3;                  % Weight coefficient for trip type Y
int: cost_x = 100;                  % Investment cost per trip X (dollars)
int: cost_y = 200;                  % Investment cost per trip Y (dollars)

% Variables
var 0..max_total_trips: trips_x;    % Number of trips of type X (integer, nonnegative)
var 0..max_total_trips: trips_y;    % Number of trips of type Y (integer, nonnegative)
var 0..(max_total_trips * max(cost_x, cost_y)): total_investment; % Total investment (dollars)

% Constraints
% Capacity constraint: total number of trips cannot exceed the maximum allowed
constraint
  trips_x + trips_y <= max_total_trips;

% Minimum offering balance: weighted sum of trips must meet the required minimum
constraint
  weight_x * trips_x + weight_y * trips_y >= min_weighted_trips;

% Investment calculation: link total_investment to the number of trips and their costs
constraint
  total_investment = cost_x * trips_x + cost_y * trips_y;

% Objective
solve minimize total_investment;