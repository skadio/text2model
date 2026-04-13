% Parameters
% Demand / requirements
int: min_total_power = 1000;              % total production must be at least this
int: max_env_expr = 500;                  % upper bound for (3*coal - gas)
int: nuclear_vs_gas_offset = 200;         % nuclear must be at least this much more than 2*gas

% Costs ($ per unit)
int: cost_coal = 50;
int: cost_gas = 40;
int: cost_nuclear = 60;

% Simple upper bounds (keep variables bounded for efficiency)
int: max_gas = 400;
int: max_coal = 1500;
int: max_nuclear = 2000;


% Variables
var 0..max_coal: coal;                    % integer units of coal power
var 0..max_gas: gas;                      % integer units of gas power
var 0..max_nuclear: nuclear;              % integer units of nuclear power

var int: total_cost;                      % total cost in dollars


% Constraints
% Meet minimum total power demand
constraint
  coal + gas + nuclear >= min_total_power;

% Environmental / operational regulation: (3*coal - gas) cannot exceed limit
constraint
  3 * coal - gas <= max_env_expr;

% Nuclear production must be at least (2*gas + offset)
constraint
  nuclear >= 2 * gas + nuclear_vs_gas_offset;

% Define total cost from unit costs and production amounts
constraint
  total_cost = cost_coal * coal + cost_gas * gas + cost_nuclear * nuclear;


% Objective
solve minimize total_cost;

output [
  "coal=", show(coal), "\n",
  "gas=", show(gas), "\n",
  "nuclear=", show(nuclear), "\n",
  "total_cost=", show(total_cost), "\n"
];