% Parameters
int: budget = 20000;                 % Maximum total spend on fruit ($)
int: cost_mango = 5;                 % Cost per mango ($)
int: cost_guava = 3;                 % Cost per guava ($)
int: profit_mango = 3;               % Profit per mango sold ($)
int: profit_guava = 4;               % Profit per guava sold ($)
int: min_mangos = 100;               % Minimum mangos sold per month
int: max_mangos = 150;               % Maximum mangos sold per month

% Variables
var min_mangos..max_mangos: mangos_sold;          % Number of mangos sold
var 0..max_mangos: guavas_sold;                   % Number of guavas sold (bounded above by mangos max)
var 0..(profit_mango * max_mangos + profit_guava * max_mangos): total_profit;  % Total profit ($)

% Constraints
% Link total_profit to decision variables (profit accounting)
constraint
  total_profit = profit_mango * mangos_sold + profit_guava * guavas_sold;

% Budget constraint: total spending on fruit cannot exceed available budget
constraint
  cost_mango * mangos_sold + cost_guava * guavas_sold <= budget;

% Guava-to-mango ratio constraint: guavas sold is at most one third of mangos sold
% (Use integer-safe form to avoid fractional division)
constraint
  3 * guavas_sold <= mangos_sold;

% Objective
solve maximize total_profit;