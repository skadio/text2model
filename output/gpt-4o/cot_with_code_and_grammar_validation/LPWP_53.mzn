% Parameters
int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;

int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;

int: TotalGold;
int: TotalWires;

% Upper-bound estimations for decision variables
int: maxA = min(TotalGold div GoldPerA, TotalWires div WiresPerA);
int: maxB = min(TotalGold div GoldPerB, TotalWires div WiresPerB);

% Variables
var 0..maxA: ProcessA;
var 0..maxB: ProcessB;
var int: TotalCoins;

% Constraints
constraint
    GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;

constraint
    WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

constraint
    TotalCoins = CoinsPerA * ProcessA + CoinsPerB * ProcessB;

% Objective
solve maximize TotalCoins;

output [
  "ProcessA = ", show(ProcessA), "\n",
  "ProcessB = ", show(ProcessB), "\n",
  "TotalCoins = ", show(TotalCoins), "\n"
];