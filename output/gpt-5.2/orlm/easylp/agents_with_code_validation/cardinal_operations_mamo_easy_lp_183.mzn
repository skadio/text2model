% Parameters
% Unit production costs ($ per unit)
int: cost_coal = 4;
int: cost_gas = 3;
int: cost_nuclear = 2;

% Demand requirement (minimum total production)
int: demand_min = 5000;

% Capacity limits (maximum production by source)
int: cap_coal = 3000;
int: cap_gas = 2000;
int: cap_nuclear = 1500;

% Variables
% Production quantities (whole numbers), bounded by capacities and non-negativity
var 0..cap_coal: coal_units;
var 0..cap_gas: gas_units;
var 0..cap_nuclear: nuclear_units;

% Total cost (bounded using max capacities)
var 0..(cost_coal*cap_coal + cost_gas*cap_gas + cost_nuclear*cap_nuclear): total_cost;

% Constraints
% Demand constraint: meet or exceed minimum required total production
constraint coal_units + gas_units + nuclear_units >= demand_min;

% Cost accounting: total cost equals sum of per-source costs times production
constraint
  total_cost = cost_coal * coal_units
             + cost_gas * gas_units
             + cost_nuclear * nuclear_units;

% Objective
solve minimize total_cost;