% Parameters
int: cost_raw = 5;                 % Cost per unit of raw material
int: cost_labor = 4;               % Cost per unit of labor
int: cost_transport = 6;           % Cost per unit of transportation

int: min_raw_minus_2labor = 500;   % Raw must exceed 2*labor by at least this amount
int: max_labor_plus_transport = 1000; % Upper bound on labor + transport
int: raw_minus_transport = 200;    % Raw must be exactly this many units more than transport

% Variables
var 0..1000000: raw;               % Units of raw material (nonnegative integer)
var 0..1000000: labor;             % Units of labor (nonnegative integer)
var 0..1000000: transport;         % Units of transportation (nonnegative integer)

var 0..1000000000: total_cost;     % Total cost (nonnegative integer)

% Constraints
% --- Cost accounting constraint ---
constraint
  total_cost = cost_raw * raw + cost_labor * labor + cost_transport * transport;

% --- Strategic / operational constraints ---
constraint
  raw - 2 * labor >= min_raw_minus_2labor;

constraint
  labor + transport <= max_labor_plus_transport;

constraint
  raw - transport = raw_minus_transport;

% Objective
solve minimize total_cost;

% Optional output (kept minimal and self-contained)
output [
  "raw=", show(raw), "\n",
  "labor=", show(labor), "\n",
  "transport=", show(transport), "\n",
  "total_cost=", show(total_cost), "\n"
];