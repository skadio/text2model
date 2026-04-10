% Coin Plating Operation Model

% Parameters (provided via the corresponding .dzn file)
int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;
int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;
int: TotalGold;
int: TotalWires;

% Decision variables: number of times each process is executed.
% We set the upper bound for each process execution to TotalGold, which is a safe overestimate.
var 0..TotalGold: ProcessA;
var 0..TotalGold: ProcessB;

% Resource constraints
constraint 
    GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;
constraint 
    WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

% Objective: maximize the total number of coins plated.
solve maximize CoinsPerA * ProcessA + CoinsPerB * ProcessB;

output [
  "ProcessA = ", show(ProcessA), "\n",
  "ProcessB = ", show(ProcessB), "\n",
  "Total Coins = ", show(CoinsPerA * ProcessA + CoinsPerB * ProcessB), "\n"
];