% Crop planning profit maximization (all data embedded)

include "globals.mzn";

% Decision variables: acres planted (integers)
var 0..600: wheat;      % Wheat max 600
var 0..400: corn;       % Corn max 400
var 0..350: soybean;    % Soybean max 350
var 0..300: rice;       % Rice max 300

% Profit per acre
int: pw = 4;
int: pc = 3;
int: ps = 2;
int: pr = 1;

% Constraints
constraint wheat + corn <= 1000;
constraint soybean + rice <= 800;

constraint wheat >= soybean + 200;      % at least 200 more wheat than soybean
constraint abs(corn - rice) <= 500;     % no more than 500 acres difference (redundant but included)

% Objective: maximize total profit
var int: profit = pw*wheat + pc*corn + ps*soybean + pr*rice;

solve maximize profit;

output [
  "Wheat acres = ", show(wheat), "\n",
  "Corn acres = ", show(corn), "\n",
  "Soybean acres = ", show(soybean), "\n",
  "Rice acres = ", show(rice), "\n",
  "Maximum total profit ($) = ", show(profit), "\n"
];