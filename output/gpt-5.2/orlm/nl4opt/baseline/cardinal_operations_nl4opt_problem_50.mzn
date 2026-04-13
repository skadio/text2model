% Snack mix production linear optimization (all data embedded)

% Data
float: cat_available = 20.0;      % kg
float: shark_available = 50.0;    % kg

float: p1_cat = 0.20;
float: p1_shark = 0.80;
float: p2_cat = 0.35;
float: p2_shark = 0.65;

float: profit1 = 12.0;           % $/kg
float: profit2 = 15.0;           % $/kg

% Decision variables (kg of each mix)
var 0.0..1.0e9: x1;  % kg of mix 1
var 0.0..1.0e9: x2;  % kg of mix 2

% Resource constraints
constraint p1_cat * x1 + p2_cat * x2 <= cat_available;
constraint p1_shark * x1 + p2_shark * x2 <= shark_available;

% Objective: maximize profit
var float: total_profit = profit1 * x1 + profit2 * x2;
solve maximize total_profit;

output [
  "Mix1_kg = ", show(x1), "\n",
  "Mix2_kg = ", show(x2), "\n",
  "TotalProfit = ", show(total_profit), "\n"
];