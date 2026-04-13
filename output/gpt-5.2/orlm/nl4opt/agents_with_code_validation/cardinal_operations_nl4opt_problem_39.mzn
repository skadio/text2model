% Parameters
% Production bounds (gallons per week)
int: min_chocolate = 5;
int: max_chocolate = 10;
int: min_vanilla   = 5;
int: max_vanilla   = 8;

% Time requirements (hours per gallon) and weekly time availability
int: hours_per_gallon_chocolate = 1;
int: hours_per_gallon_vanilla   = 2;
int: total_hours_available      = 30;

% Worker requirements (workers needed per gallon unit "at any time") and minimum workers
int: workers_per_gallon_chocolate = 1;
int: workers_per_gallon_vanilla   = 2;
int: min_workers_needed           = 6;

% Profit per gallon ($ per gallon)
int: profit_per_gallon_chocolate = 200;
int: profit_per_gallon_vanilla   = 300;


% Variables
var min_chocolate..max_chocolate: gallons_chocolate; % gallons of chocolate to produce
var min_vanilla..max_vanilla:     gallons_vanilla;   % gallons of vanilla to produce

var int: total_profit; % total weekly profit


% Constraints
% Profit definition
constraint
  total_profit =
    profit_per_gallon_chocolate * gallons_chocolate
  + profit_per_gallon_vanilla   * gallons_vanilla;

% Weekly production time capacity (hours)
constraint
  hours_per_gallon_chocolate * gallons_chocolate
+ hours_per_gallon_vanilla   * gallons_vanilla
<= total_hours_available;

% Minimum staffing requirement (workers)
constraint
  workers_per_gallon_chocolate * gallons_chocolate
+ workers_per_gallon_vanilla   * gallons_vanilla
>= min_workers_needed;


% Objective
solve maximize total_profit;