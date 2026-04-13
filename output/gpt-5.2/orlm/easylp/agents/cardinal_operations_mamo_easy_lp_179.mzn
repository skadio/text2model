% Parameters
% Demand and constraint thresholds (embedded from problem description)
int: demand_min = 1000;                 % total power must be at least this
int: coal_gas_limit = 500;              % 3*coal - gas must be <= this
int: nuclear_offset = 200;              % nuclear >= 2*gas + this

% Unit costs (dollars per unit)
int: cost_coal = 50;
int: cost_gas = 40;
int: cost_nuclear = 60;

% Variables
var 0..demand_min: coal;                % coal power produced (integer, nonnegative)
var 0..demand_min: gas;                 % gas power produced (integer, nonnegative)
var 0..(10*demand_min): nuclear;         % nuclear power produced (integer, nonnegative, safe upper bound)

% Total cost (bounded, integer)
var 0..(cost_coal*demand_min + cost_gas*demand_min + cost_nuclear*(10*demand_min)): total_cost;

% Constraints
% Demand satisfaction: total production must meet or exceed minimum demand
constraint coal + gas + nuclear >= demand_min;

% Environmental/operational limit: 3*coal - gas cannot exceed the specified limit
constraint 3 * coal - gas <= coal_gas_limit;

% Nuclear production requirement: nuclear must be at least 200 more than twice gas
constraint nuclear >= 2 * gas + nuclear_offset;

% Total cost accounting: compute total_cost from production quantities and unit costs
constraint total_cost = cost_coal * coal + cost_gas * gas + cost_nuclear * nuclear;

% Objective
solve minimize total_cost;