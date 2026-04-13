% Parameters

% Machine types: 1 = top-loading, 2 = front-loading
set of int: TYPES = 1..2;

% Capacity (items/day) per machine type
array[TYPES] of int: capacity = [50, 75];

% Energy consumption (kWh/day) per machine type
array[TYPES] of int: energy = [85, 100];

% Daily requirements and limits
int: min_items = 5000;        % must wash at least this many items per day
int: max_energy = 7000;       % available kWh per day

% Policy constraints
float: max_top_fraction = 0.40; % at most this fraction of machines can be top-loading (not used directly)
int: min_front = 10;            % at least this many front-loading machines

% Useful indices
int: TOP = 1;
int: FRONT = 2;

% Simple upper bounds derived from requirements (safe finite bounds)
int: ub_total = (min_items + min(capacity) - 1) div min(capacity); % worst-case if all are smallest-capacity
int: ub_top = ub_total;
int: ub_front = ub_total;


% Variables

var 0..ub_top:   n_top;    % number of top-loading machines to buy
var 0..ub_front: n_front;  % number of front-loading machines to buy
var 0..ub_total: n_total;  % total number of machines


% Constraints

% Link total machines to the sum of each type
constraint
  n_total = n_top + n_front;

% Meet minimum daily washing capacity (items/day)
constraint
  capacity[TOP] * n_top + capacity[FRONT] * n_front >= min_items;

% Respect daily energy availability (kWh/day)
constraint
  energy[TOP] * n_top + energy[FRONT] * n_front <= max_energy;

% Policy: at most max_top_fraction of machines can be top-loading
% Avoid floats by cross-multiplying: n_top / n_total <= 0.40  <=>  5*n_top <= 2*n_total
constraint
  5 * n_top <= 2 * n_total;

% Policy: at least min_front front-loading machines
constraint
  n_front >= min_front;


% Objective

solve minimize n_total;