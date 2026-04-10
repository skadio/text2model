% Parameters
% Demand requirement (MW)
int: min_total_capacity = 1000;

% Cost per MW ($/MW)
int: cost_coal    = 50;
int: cost_gas     = 60;
int: cost_solar   = 70;
int: cost_nuclear = 80;

% Operational bounds (MW)
int: coal_min    = 0;
int: coal_max    = 600;

int: gas_min     = 0;
int: gas_max     = 400;

int: solar_min   = 300;
int: solar_max   = 10000; % no explicit max given; use a safe large upper bound

int: nuclear_min = 100;
int: nuclear_max = 10000; % no explicit max given; use a safe large upper bound

% Additional constraints
int: coal_emission_cap = 500;         % coal max due to regulations (MW)
int: solar_minus_nuclear_min = 200;   % solar must exceed nuclear by at least (MW)
int: gas_solar_diff_max = 150;        % |gas - solar| <= 150 (MW)

% Variables
% Plant outputs (whole MW)
var coal_min..coal_max: coal_output;
var gas_min..gas_max: gas_output;
var solar_min..solar_max: solar_output;
var nuclear_min..nuclear_max: nuclear_output;

% Total output and total cost
var 0..(coal_max + gas_max + solar_max + nuclear_max): total_output;
var 0..(cost_coal*coal_max + cost_gas*gas_max + cost_solar*solar_max + cost_nuclear*nuclear_max): total_cost;

% Constraints
% -----------------------------
% Link aggregate variables
% -----------------------------
constraint total_output =
  coal_output + gas_output + solar_output + nuclear_output;

constraint total_cost =
  cost_coal    * coal_output +
  cost_gas     * gas_output +
  cost_solar   * solar_output +
  cost_nuclear * nuclear_output;

% -----------------------------
% Demand requirement
% -----------------------------
constraint total_output >= min_total_capacity;

% -----------------------------
% Operational bounds per plant
% (already enforced by variable domains; kept as explicit constraints if desired)
% -----------------------------
constraint coal_output    >= coal_min /\ coal_output    <= coal_max;
constraint gas_output     >= gas_min  /\ gas_output     <= gas_max;
constraint solar_output   >= solar_min /\ solar_output  <= solar_max;
constraint nuclear_output >= nuclear_min /\ nuclear_output <= nuclear_max;

% -----------------------------
% Additional regulatory / policy constraints
% -----------------------------

% Coal emissions regulation: tighter cap than the general coal_max
constraint coal_output <= coal_emission_cap;

% Renewable target: solar exceeds nuclear by at least a minimum margin
constraint solar_output - nuclear_output >= solar_minus_nuclear_min;

% Grid stability: gas and solar outputs must be close (bounded absolute difference)
constraint abs(gas_output - solar_output) <= gas_solar_diff_max;

% Objective
solve minimize total_cost;