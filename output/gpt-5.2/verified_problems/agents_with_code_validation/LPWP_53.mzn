% Parameters
% Resource usage and yield per run for each process
int: GoldPerA;        % Gold required per run of process A
int: WiresPerA;       % Wires required per run of process A
int: CoinsPerA;       % Coins plated per run of process A

int: GoldPerB;        % Gold required per run of process B
int: WiresPerB;       % Wires required per run of process B
int: CoinsPerB;       % Coins plated per run of process B

% Total available resources
int: TotalGold;       % Total available gold
int: TotalWires;      % Total available wires


% Variables
% Number of runs of each process (non-negative integers)
var 0..TotalGold: ProcessA;   % Upper bound by TotalGold is safe (can be tightened if desired)
var 0..TotalGold: ProcessB;   % Upper bound by TotalGold is safe (can be tightened if desired)

% Total coins plated (derived)
var 0..(CoinsPerA * TotalGold + CoinsPerB * TotalGold): TotalCoins;


% Constraints
% Resource constraint: total gold used by both processes cannot exceed available gold
constraint
  GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;

% Resource constraint: total wires used by both processes cannot exceed available wires
constraint
  WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

% Accounting constraint: define total coins plated from the chosen number of runs
constraint
  TotalCoins = CoinsPerA * ProcessA + CoinsPerB * ProcessB;


% Objective
solve maximize TotalCoins;