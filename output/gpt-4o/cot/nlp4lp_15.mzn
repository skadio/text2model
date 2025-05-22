% Parameters
int: P;
set of int: PRODUCTS = 1..P;

float: Cash;

array[PRODUCTS] of int: Hour;
array[PRODUCTS] of float: Cost;
array[PRODUCTS] of float: Price;
array[PRODUCTS] of float: InvestPercentage;

int: UpgradeHours;
float: UpgradeCost;
int: AvailableHours;

% Derived upper bounds for production quantities
array[PRODUCTS] of int: UBHour = [ (AvailableHours + UpgradeHours) div Hour[p] | p in PRODUCTS ];
int: maxUB = max(p in PRODUCTS)(UBHour[p]);

% Decision variables
array[PRODUCTS] of var 0..maxUB: q;      % quantity produced of each product
var 0..1: upgrade;                       % 1 if machinery is upgraded, 0 otherwise

% Constraints
constraint
    forall(p in PRODUCTS)(
        q[p] <= UBHour[p]
    );

% Machine-hour capacity (optionally expanded if upgrade is chosen)
constraint
    sum(p in PRODUCTS)(Hour[p] * q[p])
    <= AvailableHours + upgrade * UpgradeHours;

% Cash-flow constraint
constraint
    sum(p in PRODUCTS)(Cost[p] * int2float(q[p])) + UpgradeCost * int2float(upgrade)
    <= Cash + sum(p in PRODUCTS)(InvestPercentage[p] * Price[p] * int2float(q[p]));

% Objective: maximise total net income
var float: profit =
    sum(p in PRODUCTS)((Price[p] - Cost[p]) * int2float(q[p])) - UpgradeCost * int2float(upgrade);

solve maximize profit;