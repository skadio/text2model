% Parameters
int: max_minutes_per_day = 300;          % Maximum available minutes per day on each machine

int: heat_time_regular = 3;              % Heating time per regular pane (minutes)
int: cool_time_regular = 5;              % Cooling time per regular pane (minutes)

int: heat_time_tempered = 5;             % Heating time per tempered pane (minutes)
int: cool_time_tempered = 8;             % Cooling time per tempered pane (minutes)

int: profit_regular = 8;                 % Profit per regular pane ($)
int: profit_tempered = 10;               % Profit per tempered pane ($)

% Variables
var 0..(max_minutes_per_day div heat_time_regular): regular_panes;    % Number of regular panes produced
var 0..(max_minutes_per_day div heat_time_tempered): tempered_panes;  % Number of tempered panes produced

var 0..(profit_regular*(max_minutes_per_day div heat_time_regular)
      + profit_tempered*(max_minutes_per_day div heat_time_tempered)): total_profit; % Total profit ($)

% Constraints

% Heating machine capacity constraint (total heating time within daily limit)
constraint
  heat_time_regular * regular_panes + heat_time_tempered * tempered_panes
  <= max_minutes_per_day;

% Cooling machine capacity constraint (total cooling time within daily limit)
constraint
  cool_time_regular * regular_panes + cool_time_tempered * tempered_panes
  <= max_minutes_per_day;

% Total profit definition (link profit variable to decision variables)
constraint
  total_profit = profit_regular * regular_panes + profit_tempered * tempered_panes;

% Objective
solve maximize total_profit;