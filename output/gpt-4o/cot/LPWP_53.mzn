% Parameters
int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;

int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;

int: TotalGold;
int: TotalWires;

% Derived bounds (maximum feasible runs for each process)
int: MaxA = min(TotalGold div GoldPerA, TotalWires div WiresPerA);
int: MaxB = min(TotalGold div GoldPerB, TotalWires div WiresPerB);

% Variables
var 0..MaxA: ProcessA;
var 0..MaxB: ProcessB;

% Constraints
constraint ProcessA * GoldPerA + ProcessB * GoldPerB <= TotalGold;
constraint ProcessA * WiresPerA + ProcessB * WiresPerB <= TotalWires;

% Objective
solve maximize ProcessA * CoinsPerA + ProcessB * CoinsPerB;