var int: xA >= 0; % servings of supplement A
var int: xB >= 0; % servings of supplement B

% Data (grams per serving)
int: CaA = 30;
int: MgA = 50;
int: CaB = 60;
int: MgB = 10;

% Requirements (grams)
int: reqCa = 400;
int: reqMg = 50;

% Costs ($ per serving)
int: costA = 14;
int: costB = 25;

constraint CaA * xA + CaB * xB >= reqCa;
constraint MgA * xA + MgB * xB >= reqMg;

var int: total_cost = costA * xA + costB * xB;

solve minimize total_cost;

output [
  "Servings of A = ", show(xA), "\n",
  "Servings of B = ", show(xB), "\n",
  "Total daily cost = $", show(total_cost), "\n"
];