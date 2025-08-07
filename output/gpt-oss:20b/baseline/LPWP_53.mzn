int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;
int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;
int: TotalGold;
int: TotalWires;

var int: ProcessA;
var int: ProcessB;

constraint ProcessA >= 0;
constraint ProcessB >= 0;

constraint ProcessA * GoldPerA + ProcessB * GoldPerB <= TotalGold;
constraint ProcessA * WiresPerA + ProcessB * WiresPerB <= TotalWires;

solve maximize ProcessA * CoinsPerA + ProcessB * CoinsPerB;

output [
  "ProcessA: ", show(ProcessA), "\n",
  "ProcessB: ", show(ProcessB), "\n",
  "TotalCoins: ", show(ProcessA * CoinsPerA + ProcessB * CoinsPerB), "\n"
];