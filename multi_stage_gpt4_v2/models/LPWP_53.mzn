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

% The total gold used by both processes should not exceed the total available gold
constraint ProcessA * GoldPerA + ProcessB * GoldPerB <= TotalGold;

% The total wires used by both processes should not exceed the total available wires
constraint ProcessA * WiresPerA + ProcessB * WiresPerB <= TotalWires;

% Objective
solve maximize ProcessA * CoinsPerA + ProcessB * CoinsPerB;