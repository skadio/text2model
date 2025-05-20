% Parameters
int: ProcessA; % Number of times process A is run
int: ProcessB; % Number of times process B is run
int: GoldPerA; % Gold required per run of process A
int: WiresPerA; % Wires required per run of process A
int: CoinsPerA; % Coins plated per run of process A
int: GoldPerB; % Gold required per run of process B
int: WiresPerB; % Wires required per run of process B
int: CoinsPerB; % Coins plated per run of process B
int: TotalGold; % Total available gold
int: TotalWires; % Total available wires

% Variables
var 0..ProcessA: A; % Number of times process A is actually run
var 0..ProcessB: B; % Number of times process B is actually run

% Objective
maximize A*CoinsPerA + B*CoinsPerB;

% Constraints
constraint A*GoldPerA + B*GoldPerB <= TotalGold;
constraint A*WiresPerA + B*WiresPerB <= TotalWires;

solve satisfy;