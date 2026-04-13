% Farm crop allocation (maximize profit)
% All data embedded as per instructions.

% Decision variables: acres allocated to each crop (nonnegative integers)
var 0..100: corn;
var 0..100: wheat;
var 0..100: soybeans;
var 0..100: sorghum;

% Total land available
constraint corn + wheat + soybeans + sorghum = 100;

% Constraints from description
constraint corn >= 2 * wheat;
constraint soybeans * 2 >= sorghum;       % soybeans >= 0.5 * sorghum
constraint wheat = 3 * sorghum;

% Objective: maximize total profit
var int: profit = 1500 * corn + 1200 * wheat + 1800 * soybeans + 1600 * sorghum;

solve maximize profit;

output [
  "corn=", show(corn), " acres\n",
  "wheat=", show(wheat), " acres\n",
  "soybeans=", show(soybeans), " acres\n",
  "sorghum=", show(sorghum), " acres\n",
  "profit=$", show(profit), "\n"
];