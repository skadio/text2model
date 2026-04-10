% Dairy production planning (LP) - maximize daily profit
include "globals.mzn";

% --- Data (embedded from problem statement) ---
int: milk_barrels = 50;

% Product A1 (Type A equipment)
int: kgA1_per_barrel = 3;
int: hoursA1_per_barrel = 12;
int: profitA1_per_kg = 24;
int: capA1_kg = 100;

% Product A2 (Type B equipment)
int: kgA2_per_barrel = 4;
int: hoursA2_per_barrel = 8;
int: profitA2_per_kg = 16;
% Type B capacity unlimited

% Labor availability
int: labor_hours = 480;

% --- Decision variables ---
% x = barrels of milk processed into A1, y = barrels processed into A2
var 0..milk_barrels: x;
var 0..milk_barrels: y;

% --- Constraints ---
% Milk supply
constraint x + y <= milk_barrels;

% Labor time
constraint hoursA1_per_barrel * x + hoursA2_per_barrel * y <= labor_hours;

% Type A daily production capacity in kg
constraint kgA1_per_barrel * x <= capA1_kg;

% --- Objective: maximize profit ---
var int: profit =
  profitA1_per_kg * (kgA1_per_barrel * x) +
  profitA2_per_kg * (kgA2_per_barrel * y);

solve maximize profit;

output [
  "Barrels to A1 (x) = ", show(x), "\n",
  "Barrels to A2 (y) = ", show(y), "\n",
  "A1 produced (kg)  = ", show(kgA1_per_barrel * x), "\n",
  "A2 produced (kg)  = ", show(kgA2_per_barrel * y), "\n",
  "Labor used (h)    = ", show(hoursA1_per_barrel * x + hoursA2_per_barrel * y), "\n",
  "Profit (yuan)     = ", show(profit), "\n"
];