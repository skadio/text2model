% Candy production profit maximization (LP)
% Data embedded from Table 1-7

% Decision variables: kg produced of each candy brand
var float: xA >= 0.0;
var float: xB >= 0.0;
var float: xC >= 0.0;

% For each brand j in {A,B,C}, amount (kg) of raw material i in {A,B,C} used
var float: aA >= 0.0; var float: bA >= 0.0; var float: cA >= 0.0;  % in candy A
var float: aB >= 0.0; var float: bB >= 0.0; var float: cB >= 0.0;  % in candy B
var float: aC >= 0.0; var float: bC >= 0.0; var float: cC >= 0.0;  % in candy C

% Mass balance: composition sums to produced amount
constraint aA + bA + cA = xA;
constraint aB + bB + cB = xB;
constraint aC + bC + cC = xC;

% Composition constraints from table:
% Candy A: A >= 60%, B >= 15%  (no explicit constraint on C)
constraint aA >= 0.60 * xA;
constraint bA >= 0.15 * xA;

% Candy C: A <= 20%, B <= 60%, C <= 50%
constraint aC <= 0.20 * xC;
constraint bC <= 0.60 * xC;
constraint cC <= 0.50 * xC;

% (Candy B has no given composition constraints)

% Monthly limits on raw materials (sum across all candies)
constraint aA + aB + aC <= 2000.0;  % raw A
constraint bA + bB + bC <= 2500.0;  % raw B
constraint cA + cB + cC <= 1200.0;  % raw C

% Costs and prices (Yuan/kg)
float: costA = 2.00;
float: costB = 1.50;
float: costC = 1.00;

float: procA = 0.50;
float: procB = 0.40;
float: procC = 0.30;

float: sellA = 3.40;
float: sellB = 2.85;
float: sellC = 2.25;

% Profit = revenue - raw material cost - processing fee
var float: revenue = sellA*xA + sellB*xB + sellC*xC;
var float: rawCost = costA*(aA+aB+aC) + costB*(bA+bB+bC) + costC*(cA+cB+cC);
var float: procCost = procA*xA + procB*xB + procC*xC;
var float: profit = revenue - rawCost - procCost;

solve maximize profit;

output [
  "Optimal production (kg/month):\n",
  "  xA = ", show(xA), "\n",
  "  xB = ", show(xB), "\n",
  "  xC = ", show(xC), "\n\n",
  "Raw usage totals (kg):\n",
  "  A_total = ", show(aA+aB+aC), " / 2000\n",
  "  B_total = ", show(bA+bB+bC), " / 2500\n",
  "  C_total = ", show(cA+cB+cC), " / 1200\n\n",
  "Profit (Yuan/month) = ", show(profit), "\n"
];