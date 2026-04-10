int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;

int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;

int: TotalGold;
int: TotalWires;

var 0..TotalGold div max(1, min(GoldPerA, GoldPerB)): ProcessA;
var 0..TotalGold div max(1, min(GoldPerA, GoldPerB)): ProcessB;

constraint GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;
constraint WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

var int: TotalCoins = CoinsPerA * ProcessA + CoinsPerB * ProcessB;

solve maximize TotalCoins;

output [
  "ProcessA=", show(ProcessA), "\n",
  "ProcessB=", show(ProcessB), "\n",
  "TotalCoins=", show(TotalCoins), "\n",
  "GoldUsed=", show(GoldPerA * ProcessA + GoldPerB * ProcessB), "\n",
  "WiresUsed=", show(WiresPerA * ProcessA + WiresPerB * ProcessB), "\n"
];