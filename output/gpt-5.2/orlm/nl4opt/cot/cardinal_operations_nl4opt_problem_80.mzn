% Parameters (with values embedded)
int: max_color = 20;
int: max_bw = 30;
int: max_total_machine = 35;

int: profit_color = 200;
int: profit_bw = 70;

% Variables
var 0..max_color: color_printers;
var 0..max_bw: bw_printers;

% Constraints
constraint color_printers + bw_printers <= max_total_machine;

% Objective
solve maximize profit_color * color_printers + profit_bw * bw_printers;