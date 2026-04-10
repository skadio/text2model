% Parameters
int: heat_new = 10;                 % apartments heated by one new-model furnace
int: heat_old = 15;                 % apartments heated by one old-model furnace
int: kwh_new  = 200;                % kWh/day consumed by one new-model furnace
int: kwh_old  = 250;                % kWh/day consumed by one old-model furnace

int: min_apartments = 200;          % minimum apartments to heat
int: max_kwh        = 3500;         % available electricity (kWh/day)

float: max_old_frac = 0.35;         % at most this fraction of furnaces may be old-model
int: min_new_count  = 5;            % at least this many new-model furnaces must be used

% Variables
% Upper bounds derived from electricity limit (safe integer bounds):
% new_count <= floor(3500/200)=17, old_count <= floor(3500/250)=14
var 0..17: new_count;               % number of new-model furnaces to purchase
var 0..14: old_count;               % number of old-model furnaces to purchase

var 0..31: total_furnaces;          % total number of furnaces (new + old)

% Constraints
% Total furnaces definition
constraint
  total_furnaces = new_count + old_count;

% Heating requirement: must heat at least the minimum number of apartments
constraint
  heat_new * new_count + heat_old * old_count >= min_apartments;

% Electricity consumption limit: must not exceed available kWh/day
constraint
  kwh_new * new_count + kwh_old * old_count <= max_kwh;

% Minimum number of new-model furnaces
constraint
  new_count >= min_new_count;

% Old-model fraction limit: old_count / total_furnaces <= max_old_frac
% Avoid division by using a linearized form with integer coefficients:
% old_count <= 0.35 * total_furnaces  <=>  20*old_count <= 7*total_furnaces
constraint
  20 * old_count <= 7 * total_furnaces;

% Objective
solve minimize total_furnaces;