% Parameters
int: GoldPerA;        % Gold required per run of process A
int: WiresPerA;       % Wires required per run of process A
int: CoinsPerA;       % Coins plated per run of process A

int: GoldPerB;        % Gold required per run of process B
int: WiresPerB;       % Wires required per run of process B
int: CoinsPerB;       % Coins plated per run of process B

int: TotalGold;       % Total available gold
int: TotalWires;      % Total available wires


% Variables
% Upper bounds derived from the tightest possible limits implied by resources.
% (Using TotalGold as an easy bound is valid; these are slightly tighter and still safe.)
var 0..(TotalGold div max(1, GoldPerA)): ProcessA;   % Number of times process A is run
var 0..(TotalGold div max(1, GoldPerB)): ProcessB;   % Number of times process B is run

var 0..(CoinsPerA * (TotalGold div max(1, GoldPerA)) + CoinsPerB * (TotalGold div max(1, GoldPerB))): TotalCoins; % Total coins plated


% Constraints
% Resource usage: do not exceed available gold
constraint
    GoldPerA * ProcessA + GoldPerB * ProcessB <= TotalGold;

% Resource usage: do not exceed available wires
constraint
    WiresPerA * ProcessA + WiresPerB * ProcessB <= TotalWires;

% Define total coins plated as the sum of coins from each process
constraint
    TotalCoins = CoinsPerA * ProcessA + CoinsPerB * ProcessB;


% Objective
solve maximize TotalCoins;