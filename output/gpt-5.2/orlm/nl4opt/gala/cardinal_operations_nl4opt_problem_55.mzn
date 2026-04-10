% Berry farm profit maximization (LP formulated as an integer linear program)

% Data (embedded)
int: land = 300;          % acres available
int: budget = 10000;      % dollars for watering
int: labor_avail = 575;   % labor-days available

int: labor_blue = 6;      % labor-days per acre blueberries
int: water_blue = 22;     % $ per acre blueberries
int: profit_blue = 56;    % $ profit per acre blueberries

int: labor_rasp = 3;      % labor-days per acre raspberries
int: water_rasp = 25;     % $ per acre raspberries
int: profit_rasp = 75;    % $ profit per acre raspberries

% Decision variables: acres planted
var 0..land: blue;        % acres of blueberries
var 0..land: rasp;        % acres of raspberries

% Resource constraints
constraint blue + rasp <= land;
constraint labor_blue * blue + labor_rasp * rasp <= labor_avail;
constraint water_blue * blue + water_rasp * rasp <= budget;

% Objective: maximize profit
var int: total_profit = profit_blue * blue + profit_rasp * rasp;

solve maximize total_profit;

output [
  "Blueberries acres = ", show(blue), "\n",
  "Raspberries acres  = ", show(rasp), "\n",
  "Total profit       = ", show(total_profit), "\n",
  "Labor used         = ", show(labor_blue*blue + labor_rasp*rasp), " / ", show(labor_avail), "\n",
  "Water cost used    = ", show(water_blue*blue + water_rasp*rasp), " / ", show(budget), "\n",
  "Land used          = ", show(blue+rasp), " / ", show(land), "\n"
];