% Parameters
int: bike_meal_capacity = 8;         % Meals a bike can carry
int: scooter_meal_capacity = 5;      % Meals a scooter can carry
int: bike_charge = 3;               % Charge units required per bike
int: scooter_charge = 2;            % Charge units required per scooter
int: total_charge_available = 200;  % Total charge units available

float: max_bike_fraction = 0.30;    % At most this fraction of vehicles can be bikes
int: min_scooters = 20;             % At least this many scooters must be used

% Variables
var 0..(total_charge_available div bike_charge): num_bikes;  % Number of bikes used
var min_scooters..(total_charge_available div scooter_charge): num_scooters; % Number of scooters used

var 0..(bike_meal_capacity * (total_charge_available div bike_charge)
        + scooter_meal_capacity * (total_charge_available div scooter_charge)): total_meals; % Total meals delivered

% Constraints
% Total meals delivered is determined by the number of bikes and scooters used
constraint
  total_meals = bike_meal_capacity * num_bikes
              + scooter_meal_capacity * num_scooters;

% Total charge usage cannot exceed the available charge budget
constraint
  bike_charge * num_bikes + scooter_charge * num_scooters <= total_charge_available;

% Policy constraint: at most max_bike_fraction of all vehicles can be bikes
% Avoid floating-point in constraints by cross-multiplying (0.30 -> 30/100).
constraint
  100 * num_bikes <= ceil(max_bike_fraction * 100.0) * (num_bikes + num_scooters);

% Minimum scooters requirement (also enforced by variable domain, repeated for clarity)
constraint
  num_scooters >= min_scooters;

% Objective
solve maximize total_meals;