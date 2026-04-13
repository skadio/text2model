% Forest Paper production planning (LP)
% Use a solver that supports linear programming / float optimization.
% Gecode has limited float linear support and can error on float::linear.

% Processing times (minutes per ream)
float: print_time_graph = 3.0;
float: scan_time_graph  = 5.5;
float: print_time_music = 1.5;
float: scan_time_music  = 3.0;

% Machine availability (minutes per day)
float: max_print_minutes = 350.0;
float: max_scan_minutes  = 350.0;

% Profit per ream ($)
float: profit_graph = 4.0;
float: profit_music = 2.5;

% Decision variables (non-negative reams per day)
var 0.0..1.0e6: reams_graph;
var 0.0..1.0e6: reams_music;

% Capacity constraints
constraint print_time_graph * reams_graph + print_time_music * reams_music <= max_print_minutes;
constraint scan_time_graph  * reams_graph + scan_time_music  * reams_music <= max_scan_minutes;

% Objective: maximize profit
solve :: lp maximize profit_graph * reams_graph + profit_music * reams_music;

output [
  "reams_graph = ", show(reams_graph), "\n",
  "reams_music = ", show(reams_music), "\n",
  "profit = ", show(profit_graph * reams_graph + profit_music * reams_music), "\n"
];