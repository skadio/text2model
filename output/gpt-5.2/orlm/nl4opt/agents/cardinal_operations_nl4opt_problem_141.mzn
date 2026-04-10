% Parameters
int: budget = 20000;                 % Maximum spending budget ($)
int: cost_mango = 5;                 % Cost per mango ($)
int: cost_guava = 3;                 % Cost per guava ($)
int: profit_mango = 3;               % Profit per mango sold ($)
int: profit_guava = 4;               % Profit per guava sold ($)
int: min_mangos = 100;               % Minimum mangos sold per month
int: max_mangos = 150;               % Maximum mangos sold per month

% Variables
var min_mangos..max_mangos: mangos_sold;     % Number of mangos sold
var 0..(max_mangos div 3): guavas_sold;      % Number of guavas sold (also constrained by ratio)
var 0..(profit_mango*max_mangos + profit_guava*(max_mangos div 3)): total_profit; % Total profit ($)

% Constraints
% Budget constraint: total spending on fruits must not exceed available budget
constraint
  cost_mango * mangos_sold + cost_guava * guavas_sold <= budget;

% Guava-to-mango ratio constraint: guavas sold is at most one third of mangos sold
constraint
  3 * guavas_sold <= mangos_sold;

% Profit definition: total profit equals per-item profit times quantities sold
constraint
  total_profit = profit_mango * mangos_sold + profit_guava * guavas_sold;

% Objective
solve maximize total_profit;

output [
  "mangos_sold = ", show(mangos_sold), "\n",
  "guavas_sold = ", show(guavas_sold), "\n",
  "total_profit = ", show(total_profit), "\n"
];