% Energy generation planning - all data embedded

int: cost_coal    = 10;
int: cost_gas     = 15;
int: cost_nuclear = 20;
int: cost_solar   = 25;

% Decision variables (integer units)
var 0..100000: coal;
var 0..100000: gas;
var 0..100000: nuclear;
var 0..100000: solar;

% Constraints
constraint coal + gas >= 400;                      % base load capacity
constraint abs(nuclear - solar) <= 100;            % balance policy
constraint coal - nuclear >= 200;                  % resource availability
constraint gas + solar >= 500;                     % cleaner sources target

% Objective: minimize total cost
var int: total_cost =
  cost_coal * coal +
  cost_gas * gas +
  cost_nuclear * nuclear +
  cost_solar * solar;

solve minimize total_cost;

output [
  "coal=", show(coal), "\n",
  "gas=", show(gas), "\n",
  "nuclear=", show(nuclear), "\n",
  "solar=", show(solar), "\n",
  "minimum_total_cost_dollars=", show(total_cost), "\n"
];