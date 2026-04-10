% Parameters
int: tractor_capacity = 40;      % kg carried per tractor
int: car_capacity = 20;          % kg carried per car
int: min_corn_to_send = 500;     % minimum kg to be sent
int: car_to_tractor_ratio = 2;   % cars must be at least this times tractors

% Variables
% Upper bounds: if we used only tractors or only cars to meet the minimum requirement.
% Use / with ceil since div is integer division and would underestimate when not divisible.
var 0..ceil(min_corn_to_send / tractor_capacity): tractors;  % number of tractors used
var 0..ceil(min_corn_to_send / car_capacity): cars;          % number of cars used

% Constraints
% Capacity constraint: total corn transported must meet or exceed required minimum
constraint
  tractor_capacity * tractors + car_capacity * cars >= min_corn_to_send;

% Ratio constraint: cars used must be at least 'car_to_tractor_ratio' times tractors
constraint
  cars >= car_to_tractor_ratio * tractors;

% Objective
solve minimize tractors + cars;