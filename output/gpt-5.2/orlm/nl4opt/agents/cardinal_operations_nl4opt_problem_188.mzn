% Parameters
% Furnace performance and resource limits (all embedded as per instructions)
int: heat_new = 10;              % apartments heated per new furnace
int: heat_old = 15;              % apartments heated per old furnace
int: kwh_new  = 200;             % kWh/day per new furnace
int: kwh_old  = 250;             % kWh/day per old furnace

int: min_apartments = 200;       % at least this many apartments must be heated
int: max_kwh        = 3500;      % electricity available (kWh/day)

int: min_new = 5;                % at least 5 new furnaces
int: old_pct_num = 35;           % at most 35% old furnaces (numerator as percent)
int: old_pct_den = 100;          % denominator for percent

% Simple explicit upper bounds (derived from requirements and availability)
% New furnaces are bounded by kWh and by apartments need (worst-case cushion)
int: ub_new = min(max_kwh div kwh_new, (min_apartments div heat_new) + 20);
% Old furnaces are bounded by kWh and by apartments need (worst-case cushion)
int: ub_old = min(max_kwh div kwh_old, (min_apartments div heat_old) + 20);

% Variables
var 0..ub_new: n_new;              % number of new model furnaces purchased
var 0..ub_old: n_old;              % number of old model furnaces purchased

% Objective variable: total furnaces
var 0..(ub_new + ub_old): n_total; % total number of furnaces

% Constraints
% --- Total furnaces definition ---
constraint
  n_total = n_new + n_old;

% --- Minimum heating requirement (apartments) ---
constraint
  heat_new * n_new + heat_old * n_old >= min_apartments;

% --- Electricity (kWh/day) availability constraint ---
constraint
  kwh_new * n_new + kwh_old * n_old <= max_kwh;

% --- At least a minimum number of new furnaces ---
constraint
  n_new >= min_new;

% --- At most 35% of furnaces can be old ---
% n_old / (n_new + n_old) <= 35/100  ->  100*n_old <= 35*(n_new + n_old)
constraint
  old_pct_den * n_old <= old_pct_num * (n_new + n_old);

% Objective
solve minimize n_total;