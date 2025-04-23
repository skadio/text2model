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
var 0..TotalGold div min(GoldPerA, GoldPerB): ProcessA; % Number of times process A is run
var 0..TotalGold div min(GoldPerA, GoldPerB): ProcessB; % Number of times process B is run

% Constraints
constraint GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold; % Gold constraint
constraint WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires; % Wires constraint

% Objective
solve maximize CoinsPerA * ProcessA + CoinsPerB * ProcessB; % Maximize total number of coins plated