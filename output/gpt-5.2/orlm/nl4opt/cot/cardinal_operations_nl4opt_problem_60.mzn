% Parameters (with values embedded)
int: cap_dense = 45;        % guests per minute per densely-seated lift
int: cap_loose = 20;        % guests per minute per loosely-seated lift
int: elec_dense = 30;       % electricity units per densely-seated lift
int: elec_loose = 22;       % electricity units per loosely-seated lift
int: min_loose = 5;         % at least this many loosely-seated lifts
int: min_capacity = 1000;   % minimum guests per minute required
int: max_electricity = 940; % electricity available

% Upper bounds derived from electricity limit
int: max_dense = max_electricity div elec_dense;
int: max_loose = max_electricity div elec_loose;

% Variables
var 0..max_dense: x_dense;
var 0..max_loose: x_loose;

% Constraints
constraint x_loose >= min_loose;
constraint cap_dense * x_dense + cap_loose * x_loose >= min_capacity;
constraint elec_dense * x_dense + elec_loose * x_loose <= max_electricity;

% Objective
solve minimize x_dense + x_loose;