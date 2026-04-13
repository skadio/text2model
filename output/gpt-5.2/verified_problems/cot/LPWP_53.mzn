% Parameters
int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;

int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;

int: TotalGold;
int: TotalWires;

% Variables
var 0..max(TotalGold div GoldPerA, TotalWires div WiresPerA): ProcessA;
var 0..max(TotalGold div GoldPerB, TotalWires div WiresPerB): ProcessB;

var 0..(CoinsPerA * (max(TotalGold div GoldPerA, TotalWires div WiresPerA))
      + CoinsPerB * (max(TotalGold div GoldPerB, TotalWires div WiresPerB))): TotalCoins;

% Constraints
constraint GoldPerA >= 0 /\ WiresPerA >= 0 /\ CoinsPerA >= 0;
constraint GoldPerB >= 0 /\ WiresPerB >= 0 /\ CoinsPerB >= 0;
constraint TotalGold >= 0 /\ TotalWires >= 0;

constraint GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;
constraint WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

constraint TotalCoins = CoinsPerA * ProcessA + CoinsPerB * ProcessB;

% Objective
solve maximize TotalCoins;