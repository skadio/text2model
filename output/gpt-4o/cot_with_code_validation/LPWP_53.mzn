% Parameters
int: GoldPerA;
int: WiresPerA;
int: CoinsPerA;

int: GoldPerB;
int: WiresPerB;
int: CoinsPerB;

int: TotalGold;
int: TotalWires;

% Upper-bound calculations (keep variables bounded)
int: MaxProcessA = min(TotalGold div GoldPerA, TotalWires div WiresPerA);
int: MaxProcessB = min(TotalGold div GoldPerB, TotalWires div WiresPerB);

% Variables
var 0..MaxProcessA: ProcessA;  % number of runs of process A
var 0..MaxProcessB: ProcessB;  % number of runs of process B

% Constraints
constraint GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;
constraint WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

% Objective
solve maximize CoinsPerA * ProcessA + CoinsPerB * ProcessB;