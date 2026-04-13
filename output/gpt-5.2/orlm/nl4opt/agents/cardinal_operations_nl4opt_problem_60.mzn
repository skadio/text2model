% Parameters
int: capacity_dense = 45;          % guests per minute for densely-seated lift
int: capacity_loose = 20;          % guests per minute for loosely-seated lift
int: electricity_dense = 30;       % electricity units used by densely-seated lift
int: electricity_loose = 22;       % electricity units used by loosely-seated lift

int: min_loose_lifts = 5;          % minimum number of loosely-seated lifts required
int: min_total_capacity = 1000;    % minimum required guests per minute
int: max_electricity = 940;        % available electricity units

% Safe upper bounds derived from electricity limits
int: max_dense_lifts = max_electricity div electricity_dense;
int: max_loose_lifts = max_electricity div electricity_loose;

% Variables
var 0..max_dense_lifts: n_dense;                       % number of densely-seated lifts
var 0..max_loose_lifts: n_loose;                       % number of loosely-seated lifts
var 0..(max_dense_lifts + max_loose_lifts): n_total;   % total number of lifts

% Constraints

% Link total number of lifts to individual lift counts
constraint
  n_total = n_dense + n_loose;

% Enforce minimum number of loosely-seated lifts (beginner-friendly requirement)
constraint
  n_loose >= min_loose_lifts;

% Ensure the resort meets the minimum transport capacity (guests per minute)
constraint
  capacity_dense * n_dense + capacity_loose * n_loose >= min_total_capacity;

% Ensure total electricity consumption does not exceed availability
constraint
  electricity_dense * n_dense + electricity_loose * n_loose <= max_electricity;

% Objective
solve minimize n_total;