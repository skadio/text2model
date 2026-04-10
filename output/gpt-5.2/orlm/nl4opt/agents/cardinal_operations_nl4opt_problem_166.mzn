% Parameters
int: taxi_capacity = 2;                 % Employees per taxi ride
int: car_capacity  = 3;                 % Employees per company car ride
float: max_car_share = 0.60;            % At most 60% of rides are company car rides
int: min_car_rides = 30;                % At least 30 company car rides
int: min_employees = 500;               % Must transport at least 500 employees

% Variables
var 0..10000: taxi_rides;               % Number of taxi rides
var min_car_rides..10000: car_rides;    % Number of company car rides
var 0..20000: total_rides;              % Total rides (taxi + car)
var 0..100000: transported;             % Total employees transported

% Constraints
% Link aggregate variables
constraint
  total_rides = taxi_rides + car_rides;

constraint
  transported = taxi_capacity * taxi_rides + car_capacity * car_rides;

% Demand satisfaction: transport at least the required number of employees
constraint
  transported >= min_employees;

% Minimum number of company car rides (already enforced by variable domain, kept for clarity)
constraint
  car_rides >= min_car_rides;

% Limit share of company car rides: car_rides / total_rides <= max_car_share
% Use integer arithmetic to avoid float/int coercion:
% car_rides <= max_car_share * total_rides  <=>  100*car_rides <= (100*max_car_share)*total_rides
constraint
  100 * car_rides <= round(100.0 * max_car_share) * total_rides;

% Prevent degenerate division/share issues by ensuring at least one ride is taken
constraint
  total_rides >= 1;

% Objective
solve minimize taxi_rides;