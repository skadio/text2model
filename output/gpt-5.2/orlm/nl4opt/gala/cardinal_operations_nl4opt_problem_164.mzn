% Appliance sales optimization (integer linear programming)
% Data is embedded as required.

% Parameters
int: mover_avail = 20000;
int: setup_avail = 13000;

int: mover_fridge = 60;
int: setup_fridge = 20;
int: profit_fridge = 400;

int: mover_stove = 45;
int: setup_stove = 25;
int: profit_stove = 260;

% Decision variables: number sold (nonnegative integers)
% Upper bounds derived from resource limits
var 0..min(mover_avail div mover_fridge, setup_avail div setup_fridge): n_fridge;
var 0..min(mover_avail div mover_stove, setup_avail div setup_stove): n_stove;

% Resource constraints
constraint mover_fridge * n_fridge + mover_stove * n_stove <= mover_avail;
constraint setup_fridge * n_fridge + setup_stove * n_stove <= setup_avail;

% Objective: maximize profit
var int: total_profit = profit_fridge * n_fridge + profit_stove * n_stove;

solve maximize total_profit;

output [
  "Refrigerators = ", show(n_fridge), "\n",
  "Stoves        = ", show(n_stove), "\n",
  "Total profit  = $", show(total_profit), "\n",
  "Mover used    = ", show(mover_fridge*n_fridge + mover_stove*n_stove), " / ", show(mover_avail), "\n",
  "Setup used    = ", show(setup_fridge*n_fridge + setup_stove*n_stove), " / ", show(setup_avail), "\n"
];