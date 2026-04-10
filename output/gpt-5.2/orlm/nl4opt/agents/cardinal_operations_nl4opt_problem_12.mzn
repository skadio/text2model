% Parameters
int: van_capacity = 6;                 % Number of voters a van can carry
int: car_capacity = 3;                 % Number of voters a car can carry
int: min_voters = 200;                 % Minimum number of voters to transport
float: max_van_fraction = 0.30;        % Maximum fraction of vehicles that can be vans (not used directly; see constraint)

% Variables
var 0..ceil(int2float(min_voters) / int2float(van_capacity)): vans; % Number of vans used
var 0..ceil(int2float(min_voters) / int2float(car_capacity)): cars; % Number of cars used

% Constraints
% Transport capacity: ensure enough total seats for at least the minimum voters
constraint
  van_capacity * vans + car_capacity * cars >= min_voters;

% Van fraction limit: vans can be at most max_van_fraction of all vehicles
% Avoid floats by cross-multiplying:
% vans <= 0.30*(vans+cars)  <=>  10*vans <= 3*(vans+cars)  <=>  7*vans <= 3*cars
constraint
  7 * vans <= 3 * cars;

% Objective
solve minimize cars;