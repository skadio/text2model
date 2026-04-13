% Forest Paper production (LP)
% Data (embedded)
float: print_time_graph = 3.0;
float: scan_time_graph  = 5.5;
float: print_time_music = 1.5;
float: scan_time_music  = 3.0;

float: max_minutes_print = 350.0;
float: max_minutes_scan  = 350.0;

float: profit_graph = 4.0;
float: profit_music = 2.5;

% Decision variables (reams/day)
% Use integer variables to avoid float domain search issues/timeouts.
int: ub_graph = ceil(min(max_minutes_print / print_time_graph,
                         max_minutes_scan  / scan_time_graph));
int: ub_music = ceil(min(max_minutes_print / print_time_music,
                         max_minutes_scan  / scan_time_music));

var 0..ub_graph: x_graph;
var 0..ub_music: x_music;

% Constraints
constraint print_time_graph * x_graph + print_time_music * x_music <= max_minutes_print;
constraint scan_time_graph  * x_graph + scan_time_music  * x_music <= max_minutes_scan;

% Objective: maximize profit
solve maximize profit_graph * x_graph + profit_music * x_music;

output [
  "x_graph = ", show(x_graph), "\n",
  "x_music = ", show(x_music), "\n",
  "profit  = ", show(profit_graph * x_graph + profit_music * x_music), "\n"
];