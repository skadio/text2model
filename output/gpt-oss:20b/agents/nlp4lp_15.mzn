include "globals.mzn";

/* --- data ----------------------------------------------------------- */
int: P;                           % number of products
int: Cash;                        % initial cash available
array[1..P] of int: Hour;        % machine hours per unit
array[1..P] of int: Cost;        % production cost per unit
array[1..P] of int: Price;       % selling price per unit
array[1..P] of float: InvestPercentage;  % % of revenue that is reinvested
int: UpgradeHours;                % extra machine hours if we upgrade
int: UpgradeCost;                 % cash cost of the upgrade
int: AvailableHours;              % base machine hours

/* --- derived constants ---------------------------------------------- */
int: maxHours = AvailableHours + UpgradeHours;
int: maxCost  = Cash + UpgradeCost;

/* upper bound for each product quantity (very loose but safe) */
array[1..P] of int: upper_bounds =
  [ maxHours div Hour[i] +
    floor(maxCost / (Cost[i] + InvestPercentage[i] * real(Price[i]))) + 1
  | i in 1..P ];

/* --- decision variables --------------------------------------------- */
array[1..P] of var 0..upper_bounds[i] : q;   % quantity produced
var 0..1 : upgrade;                          % 1 if we pay for the upgrade

/* --- constraints ---------------------------------------------------- */
% machine capacity
constraint sum(i in 1..P)(q[i] * Hour[i]) <= AvailableHours + upgrade * UpgradeHours;

% cash available: production cost + upgrade cost + reinvestment
constraint
  sum(i in 1..P)(q[i] * Cost[i]) +
  upgrade * UpgradeCost +
  sum(i in 1..P)(q[i] * InvestPercentage[i] * Price[i]) <= Cash;

/* --- objective ----------------------------------------------------- */
solve maximize
  sum(i in 1..P)( q[i] * (Price[i] - Cost[i] - InvestPercentage[i] * Price[i]) );

/* --- output -------------------------------------------------------- */
output [
  "Quantities per product: ", show(q), "\n",
  "Upgrade performed? : ", show(upgrade), "\n",
  "Total net income : ", show(
      sum(i in 1..P)( q[i] * (Price[i] - Cost[i] - InvestPercentage[i] * Price[i]))),
  "\n"
];