% Parameters
int: capacity_dense = 45;          % guests per minute per densely-seated lift
int: capacity_loose = 20;          % guests per minute per loosely-seated lift
int: electricity_dense = 30;       % electricity units per densely-seated lift
int: electricity_loose = 22;       % electricity units per loosely-seated lift

int: min_loose_lifts = 5;          % minimum number of loosely-seated lifts
int: min_total_capacity = 1000;    % minimum total guests per minute required
int: max_electricity = 940;        % available electricity units

% Safe upper bounds from electricity limit
int: max_dense_lifts = max_electricity div electricity_dense;
int: max_loose_lifts = max_electricity div electricity_loose;

% Variables
var 0..max_dense_lifts: num_dense_lifts;                 % number of densely-seated lifts to install
var min_loose_lifts..max_loose_lifts: num_loose_lifts;   % number of loosely-seated lifts to install
var 0..(max_dense_lifts + max_loose_lifts): total_lifts; % total number of lifts installed

% Constraints

% --- Minimum number of loosely-seated lifts (beginner-friendly requirement) ---
constraint
  num_loose_lifts >= min_loose_lifts;

% --- Total capacity requirement (profitability constraint) ---
constraint
  capacity_dense * num_dense_lifts + capacity_loose * num_loose_lifts
  >= min_total_capacity;

% --- Electricity availability constraint (resource limit) ---
constraint
  electricity_dense * num_dense_lifts + electricity_loose * num_loose_lifts
  <= max_electricity;

% --- Definition of total number of lifts ---
constraint
  total_lifts = num_dense_lifts + num_loose_lifts;

% Objective
solve minimize total_lifts;