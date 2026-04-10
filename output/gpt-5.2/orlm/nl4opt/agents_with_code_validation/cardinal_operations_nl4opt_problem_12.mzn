% Parameters
int: van_capacity = 6;              % passengers per van
int: car_capacity = 3;              % passengers per car
int: min_voters = 200;              % minimum voters to transport
float: max_van_fraction = 0.30;     % at most this fraction of vehicles are vans

% Variables
% Upper bounds: in the extreme, all voters are carried by only that vehicle type.
var 0..ceil(int2float(min_voters) / int2float(van_capacity)): vans; % number of vans used
var 0..ceil(int2float(min_voters) / int2float(car_capacity)): cars; % number of cars used

% Constraints
%--- Capacity constraint: transport at least the required number of voters
constraint
  van_capacity * vans + car_capacity * cars >= min_voters;

%--- Fleet composition constraint: at most max_van_fraction of all vehicles are vans
%    vans / (vans + cars) <= max_van_fraction  ==>  vans <= max_van_fraction * (vans + cars)
%    Use float conversion to avoid integer division.
constraint
  int2float(vans) <= max_van_fraction * (int2float(vans) + int2float(cars));

% Objective
solve minimize cars;