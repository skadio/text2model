% Parameters
int: min_chocolate = 5;          % minimum gallons of chocolate to produce
int: min_vanilla = 5;            % minimum gallons of vanilla to produce
int: max_chocolate = 10;         % maximum gallons of chocolate to produce
int: max_vanilla = 8;            % maximum gallons of vanilla to produce

int: hours_per_chocolate = 1;    % production hours per gallon of chocolate
int: hours_per_vanilla = 2;      % production hours per gallon of vanilla
int: total_hours_available = 30; % total production hours available in the week

int: min_workers_needed = 6;     % at least this many workers are needed
int: workers_per_chocolate = 1;  % workers needed per gallon of chocolate (per problem statement)
int: workers_per_vanilla = 2;    % workers needed per gallon of vanilla (per problem statement)

int: profit_chocolate = 200;     % profit per gallon of chocolate
int: profit_vanilla = 300;       % profit per gallon of vanilla

% Variables
var min_chocolate..max_chocolate: gallons_chocolate; % gallons of chocolate to produce
var min_vanilla..max_vanilla: gallons_vanilla;       % gallons of vanilla to produce

% Total profit (upper bound based on max production limits)
var 0..(profit_chocolate*max_chocolate + profit_vanilla*max_vanilla): total_profit;

% Constraints
% Production bounds are already enforced by variable domains (min..max).

% Total production time cannot exceed the available hours
constraint
  hours_per_chocolate * gallons_chocolate
+ hours_per_vanilla   * gallons_vanilla
<= total_hours_available;

% Workforce requirement: at least the minimum number of workers are needed
constraint
  workers_per_chocolate * gallons_chocolate
+ workers_per_vanilla   * gallons_vanilla
>= min_workers_needed;

% Define total profit from produced gallons (objective handled in solve)
constraint
  total_profit
= profit_chocolate * gallons_chocolate
+ profit_vanilla   * gallons_vanilla;

% Objective
solve maximize total_profit;