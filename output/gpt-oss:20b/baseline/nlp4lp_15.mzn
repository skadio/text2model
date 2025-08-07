int: P;
int: Cash;
array[1..P] of int: Hour;
array[1..P] of int: Cost;
array[1..P] of int: Price;
array[1..P] of float: InvestPercentage;
int: UpgradeHours;
int: UpgradeCost;
int: AvailableHours;

var int: upgrade in 0..1;
var int: x[1..P] >= 0;

constraint sum(i in 1..P)(Hour[i] * x[i]) <= AvailableHours + UpgradeHours * upgrade;
constraint sum(i in 1..P)(Cost[i] * x[i]) + UpgradeCost * upgrade <= Cash;

var float: netIncome = sum(i in 1..P)(
    float(Price[i]) * x[i] * (1.0 - InvestPercentage[i]) - float(Cost[i]) * x[i]
);

solve maximize netIncome;

output [
    "Production plan: ", show(x), "\n",
    "Upgrade: ", show(upgrade), "\n",
    "Net income: ", show(netIncome), "\n"
];