% Coin plating optimization

% Parameters (provided in .dzn)
int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;

int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;

int: TotalGold;
int: TotalWires;

% Safe upper bounds (avoid division by zero)
int: maxA_gold = if GoldPerA > 0 then TotalGold div GoldPerA else TotalGold endif;
int: maxA_wires = if WiresPerA > 0 then TotalWires div WiresPerA else TotalWires endif;
int: maxA = min(maxA_gold, maxA_wires);

int: maxB_gold = if GoldPerB > 0 then TotalGold div GoldPerB else TotalGold endif;
int: maxB_wires = if WiresPerB > 0 then TotalWires div WiresPerB else TotalWires endif;
int: maxB = min(maxB_gold, maxB_wires);

% Decision variables
var 0..maxA: ProcessA;
var 0..maxB: ProcessB;

% Objective variable
var int: TotalCoins;

% Constraints (resource limits)
constraint GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;
constraint WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

% Total coins plated
constraint TotalCoins = CoinsPerA * ProcessA + CoinsPerB * ProcessB;

% Objective: maximize plated coins
solve maximize TotalCoins;

output [
  "ProcessA=", show(ProcessA), "\n",
  "ProcessB=", show(ProcessB), "\n",
  "TotalCoins=", show(TotalCoins), "\n"
];