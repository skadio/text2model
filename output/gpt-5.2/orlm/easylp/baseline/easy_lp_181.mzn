% Energy production planning (all data embedded)

int: demand = 500;
int: max_measure1 = 200;
int: min_measure2 = 150;

int: cost_coal = 20;
int: cost_gas = 30;
int: cost_nuclear = 40;

var 0..1000000: coal;
var 0..1000000: gas;
var 0..1000000: nuclear;

% Demand constraint
constraint coal + gas + nuclear >= demand;

% Measure 1: (1/2)*coal - (1/5)*gas + nuclear <= 200
% Multiply by 10 to keep integer arithmetic:
% 5*coal - 2*gas + 10*nuclear <= 2000
constraint 5 * coal - 2 * gas + 10 * nuclear <= 10 * max_measure1;

% Measure 2: coal - gas + 0.4*nuclear >= 150
% Multiply by 10:
% 10*coal - 10*gas + 4*nuclear >= 1500
constraint 10 * coal - 10 * gas + 4 * nuclear >= 10 * min_measure2;

var int: total_cost = cost_coal * coal + cost_gas * gas + cost_nuclear * nuclear;

solve minimize total_cost;

output [
  "coal=", show(coal), "\n",
  "gas=", show(gas), "\n",
  "nuclear=", show(nuclear), "\n",
  "total_cost=", show(total_cost), "\n"
];