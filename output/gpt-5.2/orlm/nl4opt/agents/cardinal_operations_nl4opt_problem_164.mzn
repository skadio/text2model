% Parameters
% Time requirements (minutes per unit)
int: mover_time_per_fridge = 60;
int: setup_time_per_fridge = 20;
int: mover_time_per_stove  = 45;
int: setup_time_per_stove  = 25;

% Available time (minutes)
int: mover_time_available = 20000;
int: setup_time_available = 13000;

% Profit per unit ($)
int: profit_per_fridge = 400;
int: profit_per_stove  = 260;


% Variables
% Number of refrigerators and stoves to sell (non-negative integers)
var 0..(mover_time_available div mover_time_per_fridge): num_fridges;
var 0..(mover_time_available div mover_time_per_stove):  num_stoves;

% Total profit ($) - upper bound from max possible units given mover time
var 0..(
  profit_per_fridge * (mover_time_available div mover_time_per_fridge)
+ profit_per_stove  * (mover_time_available div mover_time_per_stove)
): total_profit;


% Constraints
%--- Resource capacity constraints (time availability) ---
constraint
  mover_time_per_fridge * num_fridges
+ mover_time_per_stove  * num_stoves
<= mover_time_available; % Total mover time cannot exceed availability

constraint
  setup_time_per_fridge * num_fridges
+ setup_time_per_stove  * num_stoves
<= setup_time_available; % Total setup time cannot exceed availability

%--- Profit accounting constraint ---
constraint
  total_profit =
    profit_per_fridge * num_fridges
  + profit_per_stove  * num_stoves; % Define total profit from units sold


% Objective
solve maximize total_profit;