% Parameters
% Capacity (people per hour) per unit
int: train_capacity = 120;
int: tram_capacity  = 30;

% Minimum required total capacity (people per hour)
int: min_people_per_hour = 600;

% Relationship constraint factor: trams must be at least this multiple of trains
int: tram_to_train_min_ratio = 2;

% Safe upper bounds for decision variables (derived from requirements)
% In worst case, use only the lower-capacity unit to meet demand.
int: max_trams  = (min_people_per_hour + tram_capacity - 1) div tram_capacity;
int: max_trains = (min_people_per_hour + train_capacity - 1) div train_capacity;

% Variables
% Number of trains to build/use
var 0..max_trains: num_trains;

% Number of trams to build/use
var 0..max_trams: num_trams;

% Constraints
% --- Capacity requirement: total transported people per hour must meet demand ---
constraint
  train_capacity * num_trains + tram_capacity * num_trams >= min_people_per_hour;

% --- Build-time relationship: trams must be at least a multiple of trains ---
constraint
  num_trams >= tram_to_train_min_ratio * num_trains;

% Objective
solve minimize num_trains + num_trams;