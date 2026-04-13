% Parameters
int: max_color_per_day = 20;          % Maximum color printers that can be produced per day
int: max_bw_per_day    = 30;          % Maximum black-and-white printers that can be produced per day
int: max_total_per_day = 35;          % Shared machine capacity (total printers per day)

int: profit_color = 200;              % Profit per color printer
int: profit_bw    = 70;               % Profit per black-and-white printer

% Variables
var 0..max_color_per_day: color_printers;   % Number of color printers produced per day
var 0..max_bw_per_day: bw_printers;         % Number of black-and-white printers produced per day

var 0..(profit_color*max_color_per_day + profit_bw*max_bw_per_day): total_profit;
                                            % Total daily profit (bounded using max possible within per-team limits)

% Constraints
% Capacity constraint: shared paper tray installing machine (total daily production limit)
constraint
  color_printers + bw_printers <= max_total_per_day;

% Profit definition: link total_profit to production decisions
constraint
  total_profit = profit_color * color_printers + profit_bw * bw_printers;

% Objective
solve maximize total_profit;