% Parameters
int: nCars = 15;                              % number of cars
set of int: CARS = 1..nCars;                  % car index set

array[CARS] of float: carLength =             % length (meters) of each car
  [4.0, 4.5, 5.0, 4.1, 2.4, 5.2, 3.7, 3.5, 3.2, 4.5, 2.3, 3.3, 3.8, 4.6, 3.0];

float: maxSideLength = 30.0;                  % optional side capacity (meters)

% Variables
array[CARS] of var 0..1: onLeft;              % 1 if car i parks on left side, 0 otherwise

var 0.0..sum(carLength): leftLength;          % total occupied length on left side
var 0.0..sum(carLength): rightLength;         % total occupied length on right side

var 0.0..sum(carLength): streetOccupied;      % total street length occupied (max of both sides)

% Constraints
% --- Side-length aggregation constraints ---
% Compute total occupied length on each side as sum of assigned car lengths.
constraint
  leftLength = sum(i in CARS)(carLength[i] * onLeft[i]);

constraint
  rightLength = sum(i in CARS)(carLength[i] * (1.0 - onLeft[i]));

% --- Street occupancy definition ---
% Total street length occupied is the maximum of the two side lengths.
constraint
  streetOccupied >= leftLength;

constraint
  streetOccupied >= rightLength;

% --- Optional capacity constraint for one side ---
% If cars on one side cannot occupy more than maxSideLength meters, enforce on the left side.
constraint
  leftLength <= maxSideLength;

% Objective
solve minimize streetOccupied;