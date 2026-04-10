% Berry farm LP: maximize profit from blueberries and raspberries

% Data (embedded)
int: land_available = 300;          % acres
int: budget_available = 10000;      % dollars
int: labor_available = 575;         % labor-days

int: labor_blue = 6;               % days per acre blueberries
int: water_blue = 22;              % dollars per acre blueberries
int: profit_blue = 56;             % dollars per acre blueberries

int: labor_rasp = 3;               % days per acre raspberries
int: water_rasp = 25;              % dollars per acre raspberries
int: profit_rasp = 75;             % dollars per acre raspberries

% Decision variables: acres planted (assume integer acres)
var 0..land_available: x_blue;      % acres of blueberries
var 0..land_available: x_rasp;      % acres of raspberries

% Constraints
constraint x_blue + x_rasp <= land_available;
constraint labor_blue * x_blue + labor_rasp * x_rasp <= labor_available;
constraint water_blue * x_blue + water_rasp * x_rasp <= budget_available;

% Objective: maximize profit
var int: total_profit = profit_blue * x_blue + profit_rasp * x_rasp;
solve maximize total_profit;

output [
  "Blueberries acres = ", show(x_blue), "\n",
  "Raspberries acres = ", show(x_rasp), "\n",
  "Total profit = $", show(total_profit), "\n"
];