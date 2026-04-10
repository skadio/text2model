% Parameters
int: max_color_per_day = 20;           % Capacity of color printer team (units/day)
int: max_bw_per_day = 30;              % Capacity of B&W printer team (units/day)
int: max_total_install_per_day = 35;   % Capacity of shared paper tray installing machine (units/day)

int: profit_color = 200;               % Profit per color printer ($/unit)
int: profit_bw = 70;                   % Profit per B&W printer ($/unit)

% Variables
var 0..max_color_per_day: num_color;   % Number of color printers produced per day
var 0..max_bw_per_day: num_bw;         % Number of B&W printers produced per day
var 0..(profit_color*max_color_per_day + profit_bw*max_bw_per_day): total_profit; % Total daily profit ($)

% Constraints

% Team capacity constraints (redundant due to variable domains, kept for clarity)
constraint num_color <= max_color_per_day;
constraint num_bw <= max_bw_per_day;

% Shared paper tray installing machine capacity
constraint num_color + num_bw <= max_total_install_per_day;

% Total profit definition
constraint total_profit = profit_color * num_color + profit_bw * num_bw;

% Objective
solve maximize total_profit;

output [
  "num_color = ", show(num_color), "\n",
  "num_bw = ", show(num_bw), "\n",
  "total_profit = ", show(total_profit), "\n"
];