% Glass pane production optimization (all data embedded)

% Parameters (minutes available per day)
int: maxHeat = 300;
int: maxCool = 300;

% Processing times (minutes per pane)
int: heatReg = 3;
int: coolReg = 5;
int: heatTemp = 5;
int: coolTemp = 8;

% Profits ($ per pane)
int: profitReg = 8;
int: profitTemp = 10;

% Decision variables: number of panes (nonnegative integers)
var 0..maxHeat div heatReg: reg;
var 0..maxHeat div heatTemp: temp;

% Resource constraints
constraint heatReg * reg + heatTemp * temp <= maxHeat;
constraint coolReg * reg + coolTemp * temp <= maxCool;

% Objective: maximize total profit
var int: totalProfit = profitReg * reg + profitTemp * temp;

solve maximize totalProfit;

output [
  "Regular panes = ", show(reg), "\n",
  "Tempered panes = ", show(temp), "\n",
  "Maximum profit = $", show(totalProfit), "\n"
];