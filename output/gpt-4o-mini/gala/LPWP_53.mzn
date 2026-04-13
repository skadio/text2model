int: ProcessA;                % Number of times process A is run
int: ProcessB;                % Number of times process B is run
int: GoldPerA;                % Gold required per run of process A
int: WiresPerA;               % Wires required per run of process A
int: CoinsPerA;               % Coins plated per run of process A
int: GoldPerB;                % Gold required per run of process B
int: WiresPerB;               % Wires required per run of process B
int: CoinsPerB;               % Coins plated per run of process B
int: TotalGold;               % Total available gold
int: TotalWires;              % Total available wires

% Decision variables
var 0..TotalGold div GoldPerA: numA;  % Number of times process A is executed
var 0..TotalWires div WiresPerB: numB; % Number of times process B is executed

% Constraints
constraint GoldPerA * numA + GoldPerB * numB <= TotalGold;  % Gold constraint
constraint WiresPerA * numA + WiresPerB * numB <= TotalWires; % Wires constraint

% Objective: Maximize total coins plated
var int: totalCoins = CoinsPerA * numA + CoinsPerB * numB;

solve maximize totalCoins;

output [ "Process A runs: ", show(numA), "\n", 
         "Process B runs: ", show(numB), "\n", 
         "Total coins plated: ", show(totalCoins), "\n" ];