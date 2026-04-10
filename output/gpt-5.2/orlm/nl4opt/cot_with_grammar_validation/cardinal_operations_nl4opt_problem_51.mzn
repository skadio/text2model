float: print_time_graph = 3.0;
float: scan_time_graph  = 5.5;
float: print_time_music = 1.5;
float: scan_time_music  = 3.0;

float: max_print_time = 350.0;
float: max_scan_time  = 350.0;

float: profit_graph = 4.0;
float: profit_music = 2.5;

var 0.0..1.0e6: x_graph;
var 0.0..1.0e6: x_music;
var float: total_profit;

constraint print_time_graph * x_graph + print_time_music * x_music <= max_print_time;
constraint scan_time_graph  * x_graph + scan_time_music  * x_music <= max_scan_time;

constraint total_profit = profit_graph * x_graph + profit_music * x_music;

solve maximize total_profit;

output [
  "x_graph = ", show(x_graph), "\n",
  "x_music = ", show(x_music), "\n",
  "total_profit = ", show(total_profit), "\n"
];