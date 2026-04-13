% Parameters
int: train_capacity = 120;          % People per hour per train
int: tram_capacity  = 30;           % People per hour per tram
int: demand         = 600;          % Minimum people per hour to transport
int: tram_train_ratio = 2;          % Trams must be at least this multiple of trains

% Upper bounds for decision variables (safe, derived from demand)
int: max_trains = (demand div train_capacity) + 10;  % conservative upper bound
int: max_trams  = (demand div tram_capacity) + 10;   % conservative upper bound


% Variables
var 0..max_trains: num_trains;      % Number of trains to build/use
var 0..max_trams:  num_trams;       % Number of trams to build/use


% Constraints

% Meet or exceed passenger transport demand
constraint
  train_capacity * num_trains + tram_capacity * num_trams >= demand;

% Trams must be at least a given multiple of trains (build-time constraint)
constraint
  num_trams >= tram_train_ratio * num_trains;


% Objective
solve minimize num_trains + num_trams;