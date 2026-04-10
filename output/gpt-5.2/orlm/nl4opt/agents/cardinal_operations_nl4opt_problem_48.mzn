% Parameters
% Vehicle types
set of int: V = 1..2;
int: MOTORCYCLE = 1;
int: SEDAN = 2;

% Capacity (people per shift) for each vehicle type
array[V] of int: capacity = [30, 70];

% Pollution units produced per vehicle per shift
array[V] of int: pollution = [4, 15];

% Earnings ($) per vehicle per shift
array[V] of int: earnings = [100, 225];

% Policy / requirement parameters
int: max_total_pollution = 200;        % must be strictly less than this
int: min_people_to_transport = 1200;   % must be at least this
int: max_motorcycle_percent = 25;      % at most 25% motorcycles (of total vehicles)

% Variables
% Number of vehicles of each type to purchase/use (nonnegative integers)
array[V] of var int: num_vehicles;

% Total vehicles used (for ratio constraint)
var int: total_vehicles;

% Total pollution produced per shift
var int: total_pollution;

% Total people transported per shift
var int: total_people;

% Total earnings per shift (objective)
var int: total_earnings;


% Constraints

% --- Nonnegativity / domain constraints ---
constraint
  forall(v in V) (num_vehicles[v] >= 0);

constraint
  total_vehicles >= 0 /\ total_pollution >= 0 /\ total_people >= 0 /\ total_earnings >= 0;

% --- Linking constraints: define totals from decision variables ---
constraint
  total_vehicles = sum(v in V)(num_vehicles[v]);

constraint
  total_pollution = sum(v in V)(pollution[v] * num_vehicles[v]);

constraint
  total_people = sum(v in V)(capacity[v] * num_vehicles[v]);

constraint
  total_earnings = sum(v in V)(earnings[v] * num_vehicles[v]);

% --- Pollution policy: strictly less than maximum allowed ---
constraint
  total_pollution < max_total_pollution;

% --- Service requirement: transport at least the minimum number of people ---
constraint
  total_people >= min_people_to_transport;

% --- Fleet mix policy: at most max_motorcycle_percent% of vehicles are motorcycles ---
% Avoid division by cross-multiplying: 100 * motorcycles <= max_percent * total_vehicles
constraint
  100 * num_vehicles[MOTORCYCLE] <= max_motorcycle_percent * total_vehicles;


% Objective
solve maximize total_earnings;