include "globals.mzn";

% Decision variables: integer units generated from each source
var 0..100000: coal;
var 0..100000: gas;
var 0..100000: nuclear;
var 0..100000: solar;

% Costs ($ per unit)
int: c_coal = 10;
int: c_gas = 15;
int: c_nuclear = 20;
int: c_solar = 25;

% Constraints
constraint coal + gas >= 400;                         % baseload
constraint abs(nuclear - solar) <= 100;               % balance policy
constraint coal - nuclear >= 200;                     % resource availability
constraint gas + solar >= 500;                        % cleaner sources

% Objective: minimize total cost
var int: total_cost =
  c_coal * coal + c_gas * gas + c_nuclear * nuclear + c_solar * solar;

solve minimize total_cost;

output [
  "coal = ", show(coal), "\n",
  "gas = ", show(gas), "\n",
  "nuclear = ", show(nuclear), "\n",
  "solar = ", show(solar), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];