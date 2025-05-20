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
var 0..TotalWires div min(WiresPerA, WiresPerB): ProcessB; % Number of times process B is run

% Constraints
constraint ProcessA * GoldPerA + ProcessB * GoldPerB <= TotalGold;
constraint ProcessA * WiresPerA + ProcessB * WiresPerB <= TotalWires;

% Objective
var int: TotalCoins = ProcessA * CoinsPerA + ProcessB * CoinsPerB;
solve maximize TotalCoins;

% Output
output ["ProcessA: ", show(ProcessA), "\n",
        "ProcessB: ", show(ProcessB), "\n",
        "Total Coins: ", show(TotalCoins)];