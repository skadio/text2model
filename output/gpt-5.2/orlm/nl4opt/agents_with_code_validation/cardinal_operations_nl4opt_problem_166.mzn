% Parameters
int: taxi_capacity = 2;                 % employees per taxi ride
int: car_capacity  = 3;                 % employees per company car ride
float: max_car_ride_fraction = 0.60;    % at most 60% of all rides are company car rides
int: min_car_rides = 30;                % at least 30 company car rides
int: min_employees = 500;               % at least 500 employees must be transported

% Variables
var 0..ceil(int2float(min_employees) / int2float(taxi_capacity)): taxi_rides; % number of taxi rides
var min_car_rides..ceil(int2float(min_employees) / int2float(car_capacity)): car_rides; % number of company car rides

% Constraints
% --- Transport enough employees (capacity constraint) ---
constraint
  taxi_capacity * taxi_rides + car_capacity * car_rides >= min_employees;

% --- Company cars are at most a fraction of all rides ---
% car_rides <= max_car_ride_fraction * (taxi_rides + car_rides)
% Use integer-safe form to avoid float coercion: 100*car_rides <= 60*(taxi_rides+car_rides)
constraint
  100 * car_rides <= 60 * (taxi_rides + car_rides);

% --- Minimum number of company car rides (already enforced by variable domain, repeated for clarity) ---
constraint
  car_rides >= min_car_rides;

% Objective
solve minimize taxi_rides;