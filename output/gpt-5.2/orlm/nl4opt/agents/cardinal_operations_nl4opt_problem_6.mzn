% Parameters
int: bike_capacity = 8;          % meals per bike
int: scooter_capacity = 5;       % meals per scooter
int: bike_charge = 3;            % charge units per bike
int: scooter_charge = 2;         % charge units per scooter
int: total_charge = 200;         % total available charge units

float: max_bike_fraction = 0.30; % at most 30% of vehicles are bikes (used only in comment; enforced via integers)
int: min_scooters = 20;          % at least 20 scooters must be used


% Variables
% Safe upper bounds from charge limits
var 0..(total_charge div bike_charge): bikes;                         % number of bikes used
var min_scooters..(total_charge div scooter_charge): scooters;        % number of scooters used

var 0..(bike_capacity*(total_charge div bike_charge)
      + scooter_capacity*(total_charge div scooter_charge)): total_meals; % total meals delivered


% Constraints
% Charge budget: total charge used by bikes and scooters cannot exceed available charge
constraint
  bike_charge * bikes + scooter_charge * scooters <= total_charge;

% Scooter minimum: at least the required number of scooters must be used
constraint
  scooters >= min_scooters;

% Bike fraction limit: bikes are at most 30% of all vehicles
% bikes <= 0.30*(bikes+scooters)  <=>  10*bikes <= 3*(bikes+scooters)
constraint
  10 * bikes <= 3 * (bikes + scooters);

% Define total meals delivered based on chosen vehicles
constraint
  total_meals = bike_capacity * bikes + scooter_capacity * scooters;


% Objective
solve maximize total_meals;