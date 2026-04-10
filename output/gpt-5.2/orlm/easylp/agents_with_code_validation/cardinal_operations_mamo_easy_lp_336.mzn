% Parameters
int: cost_coal    = 10;
int: cost_gas     = 15;
int: cost_nuclear = 20;
int: cost_solar   = 25;

int: min_coal_gas           = 400; % coal + gas >= 400
int: max_nuclear_solar_diff = 100; % |nuclear - solar| <= 100
int: min_coal_over_nuclear  = 200; % coal - nuclear >= 200
int: min_gas_solar          = 500; % gas + solar >= 500

% Variables (nonnegative integer generation quantities)
var int: coal;
var int: gas;
var int: nuclear;
var int: solar;

% Total cost ($)
var int: total_cost;

% Nonnegativity
constraint coal >= 0 /\ gas >= 0 /\ nuclear >= 0 /\ solar >= 0;

% Constraints
constraint coal + gas >= min_coal_gas;
constraint abs(nuclear - solar) <= max_nuclear_solar_diff;
constraint coal - nuclear >= min_coal_over_nuclear;
constraint gas + solar >= min_gas_solar;

% Cost definition
constraint total_cost =
    cost_coal * coal
  + cost_gas * gas
  + cost_nuclear * nuclear
  + cost_solar * solar;

% Objective
solve minimize total_cost;