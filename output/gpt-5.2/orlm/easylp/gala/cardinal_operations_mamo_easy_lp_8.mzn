% Advertising budget allocation (integer dollars) minimizing total cost

% Data (embedded)
int: min_effectiveness = 50;
int: max_fatigue = 300;

int: eff_ad1 = 1;   % effectiveness points per $ for Ad1
int: eff_ad2 = 1;   % effectiveness points per $ for Ad2

int: fat_ad1 = 4;   % fatigue points per $ for Ad1
int: fat_ad2 = 6;   % fatigue points per $ for Ad2

int: cost_ad1 = 5;  % $ cost per $ allocated to Ad1 (i.e., per unit effectiveness here)
int: cost_ad2 = 3;  % $ cost per $ allocated to Ad2

% Decision variables (budgets in whole dollars)
var 0..max_fatigue div fat_ad1: ad1;
var 0..max_fatigue div fat_ad2: ad2;

% Constraints
constraint eff_ad1 * ad1 + eff_ad2 * ad2 >= min_effectiveness;
constraint fat_ad1 * ad1 + fat_ad2 * ad2 <= max_fatigue;

% Objective: minimize total cost in dollars
var int: total_cost = cost_ad1 * ad1 + cost_ad2 * ad2;

solve minimize total_cost;

output [
  "Ad1 = ", show(ad1), "\n",
  "Ad2 = ", show(ad2), "\n",
  "TotalCost = ", show(total_cost), "\n",
  "Effectiveness = ", show(eff_ad1*ad1 + eff_ad2*ad2), "\n",
  "Fatigue = ", show(fat_ad1*ad1 + fat_ad2*ad2), "\n"
];