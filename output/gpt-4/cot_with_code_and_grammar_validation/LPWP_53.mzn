% Parameters
int: GoldPerA; % Gold required per run of process A
int: WiresPerA; % Wires required per run of process A
int: CoinsPerA; % Coins plated per run of process A
int: GoldPerB; % Gold required per run of process B
int: WiresPerB; % Wires required per run of process B
int: CoinsPerB; % Coins plated per run of process B
int: TotalGold; % Total available gold
int: TotalWires; % Total available wires

% Variables
var 0..TotalGold div GoldPerA: ProcessA; % Number of times process A is run
var 0..TotalGold div GoldPerB: ProcessB; % Number of times process B is run

% Constraints
constraint GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;
constraint WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

% Objective
var int: TotalCoins = CoinsPerA * ProcessA + CoinsPerB * ProcessB;
solve maximize TotalCoins;