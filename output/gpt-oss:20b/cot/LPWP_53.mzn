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
var 0..min(TotalGold div GoldPerA, TotalWires div WiresPerA): ProcessA;
var 0..min(TotalGold div GoldPerB, TotalWires div WiresPerB): ProcessB;

% Constraints
constraint ProcessA * GoldPerA + ProcessB * GoldPerB <= TotalGold;
constraint ProcessA * WiresPerA + ProcessB * WiresPerB <= TotalWires;

% Objective
solve maximize ProcessA * CoinsPerA + ProcessB * CoinsPerB;