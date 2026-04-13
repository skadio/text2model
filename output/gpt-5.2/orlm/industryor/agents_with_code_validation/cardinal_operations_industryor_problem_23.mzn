% Parameters
int: demand = 1800;                     % Minimum total units to deliver
int: max_pollution = 2000;              % Maximum allowed total pollution
int: min_truck_trips = 10;              % Minimum number of truck trips

% Per-trip capacities (units delivered per trip)
int: cap_truck = 100;
int: cap_van = 80;
int: cap_motorcycle = 40;
int: cap_electric = 60;

% Per-trip pollution (pollution units per trip)
int: pol_truck = 100;
int: pol_van = 50;
int: pol_motorcycle = 10;
int: pol_electric = 0;

% Useful upper bound on trips: enough trips with the smallest capacity to meet demand
int: max_trips = ceil(demand / min([cap_truck, cap_van, cap_motorcycle, cap_electric]));

% Variables
var 0..max_trips: trips_truck;          % Number of truck trips
var 0..max_trips: trips_van;            % Number of van trips
var 0..max_trips: trips_motorcycle;     % Number of motorcycle trips
var 0..max_trips: trips_electric;       % Number of electric vehicle trips

var 0..max_pollution: total_pollution;  % Total pollution generated

% Total delivered units (conservative upper bound)
var 0..(demand + max_trips * max([cap_truck, cap_van, cap_motorcycle, cap_electric])): total_delivered;

% Constraints

% --- Minimum truck usage ---
constraint trips_truck >= min_truck_trips;

% --- Mutually exclusive fleet choice: vans or electric (but not both) ---
constraint (trips_van = 0) \/ (trips_electric = 0);

% --- Total delivered units must meet demand ---
constraint total_delivered =
  cap_truck * trips_truck +
  cap_van * trips_van +
  cap_motorcycle * trips_motorcycle +
  cap_electric * trips_electric;

constraint total_delivered >= demand;

% --- Total pollution accounting and cap ---
constraint total_pollution =
  pol_truck * trips_truck +
  pol_van * trips_van +
  pol_motorcycle * trips_motorcycle +
  pol_electric * trips_electric;

constraint total_pollution <= max_pollution;

% Objective
solve minimize total_pollution;