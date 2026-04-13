% Parameters
% Processing times (minutes per ream)
float: print_time_graph = 3.0;
float: scan_time_graph  = 5.5;
float: print_time_music = 1.5;
float: scan_time_music  = 3.0;

% Machine availability (minutes per day)
float: max_print_minutes = 350.0;
float: max_scan_minutes  = 350.0;

% Profit ($ per ream/package)
float: profit_graph = 4.0;
float: profit_music = 2.5;

% Variables
% Decision variables: number of reams produced per day (non-negative integers)
var 0..int_max: reams_graph;
var 0..int_max: reams_music;

% Objective variable: total profit
var float: total_profit;

% Constraints
% Printing machine capacity (minutes/day)
constraint
  print_time_graph * int2float(reams_graph) + print_time_music * int2float(reams_music)
  <= max_print_minutes;

% Scanning machine capacity (minutes/day)
constraint
  scan_time_graph * int2float(reams_graph) + scan_time_music * int2float(reams_music)
  <= max_scan_minutes;

% Total profit definition
constraint
  total_profit = profit_graph * int2float(reams_graph) + profit_music * int2float(reams_music);

% Objective
solve maximize total_profit;