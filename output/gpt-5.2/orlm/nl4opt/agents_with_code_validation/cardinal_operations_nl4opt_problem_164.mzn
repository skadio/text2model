% Parameters
% Time requirements (minutes per unit)
int: mover_time_per_refrigerator = 60;
int: setup_time_per_refrigerator = 20;
int: mover_time_per_stove        = 45;
int: setup_time_per_stove        = 25;

% Resource availability (total minutes)
int: mover_time_available = 20000;
int: setup_time_available = 13000;

% Profit per unit (dollars)
int: profit_per_refrigerator = 400;
int: profit_per_stove        = 260;

% Upper bounds derived from capacities (for bounded decision vars)
int: max_refrigerators = min(mover_time_available div mover_time_per_refrigerator,
                            setup_time_available div setup_time_per_refrigerator);
int: max_stoves        = min(mover_time_available div mover_time_per_stove,
                            setup_time_available div setup_time_per_stove);

% Variables
% Number of refrigerators and stoves to sell/install (non-negative integers)
var 0..max_refrigerators: num_refrigerators;
var 0..max_stoves: num_stoves;

% Total profit (bounded for linear objective)
var 0..(profit_per_refrigerator * max_refrigerators + profit_per_stove * max_stoves): total_profit;

% Constraints
%--- Resource capacity constraints (do not exceed available minutes) ---
constraint
  mover_time_per_refrigerator * num_refrigerators
+ mover_time_per_stove        * num_stoves
<= mover_time_available;

constraint
  setup_time_per_refrigerator * num_refrigerators
+ setup_time_per_stove        * num_stoves
<= setup_time_available;

%--- Profit accounting constraint (define total_profit consistently) ---
constraint
  total_profit =
    profit_per_refrigerator * num_refrigerators
  + profit_per_stove        * num_stoves;

% Objective
solve maximize total_profit;