% Parameters
int: tractor_capacity = 40;      % kg per tractor
int: car_capacity     = 20;      % kg per car
int: min_corn_needed  = 500;     % minimum kg to be transported
int: car_to_tractor_ratio = 2;   % cars used must be at least this multiple of tractors

% Variables
% Upper bounds are safe, simple bounds derived from meeting demand using only one vehicle type.
var 0..(ceil(min_corn_needed / tractor_capacity) + ceil(min_corn_needed / car_capacity)): tractors; % number of tractors
var 0..ceil(min_corn_needed / car_capacity): cars;                                                  % number of cars

% Constraints
% Transport requirement: total corn carried by tractors and cars must meet or exceed demand
constraint
  tractor_capacity * tractors + car_capacity * cars >= min_corn_needed;

% Speed/availability requirement: cars must be at least a multiple of tractors
constraint
  cars >= car_to_tractor_ratio * tractors;

% Objective
solve minimize tractors + cars;