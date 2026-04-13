% Parameters
int: max_minutes = 300;                 % Maximum available minutes per day on each machine

int: heat_time_regular = 3;             % Heating minutes per regular pane
int: cool_time_regular = 5;             % Cooling minutes per regular pane
int: heat_time_tempered = 5;            % Heating minutes per tempered pane
int: cool_time_tempered = 8;            % Cooling minutes per tempered pane

int: profit_regular = 8;                % Profit per regular pane ($)
int: profit_tempered = 10;              % Profit per tempered pane ($)

% Variables
% Upper bounds are safely derived from the tightest per-pane heating time (min of heating times).
var 0..(max_minutes div min(heat_time_regular, heat_time_tempered)): regular_panes;
var 0..(max_minutes div min(heat_time_regular, heat_time_tempered)): tempered_panes;

% Upper bound is a safe over-approximation based on making only one type at a time.
var 0..(profit_regular * (max_minutes div heat_time_regular)
      + profit_tempered * (max_minutes div heat_time_tempered)): total_profit;

% Constraints
% Heating machine capacity constraint (total heating time within daily limit)
constraint
  heat_time_regular * regular_panes + heat_time_tempered * tempered_panes <= max_minutes;

% Cooling machine capacity constraint (total cooling time within daily limit)
constraint
  cool_time_regular * regular_panes + cool_time_tempered * tempered_panes <= max_minutes;

% Total profit definition (link profit variable to production decisions)
constraint
  total_profit = profit_regular * regular_panes + profit_tempered * tempered_panes;

% Objective
solve maximize total_profit;