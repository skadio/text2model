% ============================================================
% COIN PLATING OPTIMIZATION MODEL
% ============================================================
%
% PROBLEM DESCRIPTION:
% -------------------
% A factory plates coins using two processes: Process A and Process B.
% - Process A consumes a fixed amount of gold and wires to plate a set number of coins.
% - Process B uses a different amount of gold and wires to plate a different number of coins.
% - The factory has a limited supply of gold and wires.
%
% OBJECTIVE:
% ----------
% Determine how many times each process should be run to **maximize**
% the total number of plated coins while staying within the resource constraints.
%
% PARAMETERS PROVIDED IN JSON:
% {
%   "GoldPerA": <int>, "WiresPerA": <int>, "CoinsPerA": <int>,
%   "GoldPerB": <int>, "WiresPerB": <int>, "CoinsPerB": <int>,
%   "TotalGold": <int>, "TotalWires": <int>
% }
% ============================================================


% -----------------------------
% 1) PARAMETERS
% -----------------------------

int: GoldPerA;      % Gold required per run of Process A
int: WiresPerA;     % Wires required per run of Process A
int: CoinsPerA;     % Coins plated per run of Process A

int: GoldPerB;      % Gold required per run of Process B
int: WiresPerB;     % Wires required per run of Process B
int: CoinsPerB;     % Coins plated per run of Process B

int: TotalGold;     % Total available gold units
int: TotalWires;    % Total available wire units


% -----------------------------
% 2) DECISION VARIABLES
% -----------------------------

% The number of times Process A and Process B will be run
var 0..TotalGold div GoldPerA: ProcessA;
var 0..TotalGold div GoldPerB: ProcessB;

% The total number of coins plated
var int: TotalCoins;


% -----------------------------
% 3) CONSTRAINTS
% -----------------------------

% (C1) Gold Constraint: The total gold used cannot exceed the available supply.
constraint
    ProcessA * GoldPerA + ProcessB * GoldPerB <= TotalGold;

% (C2) Wire Constraint: The total wires used cannot exceed the available supply.
constraint
    ProcessA * WiresPerA + ProcessB * WiresPerB <= TotalWires;

% (C3) Total Coins Calculation
% The total coins plated is the sum of coins plated from both processes.
constraint
    TotalCoins = ProcessA * CoinsPerA + ProcessB * CoinsPerB;


% -----------------------------
% 4) OBJECTIVE FUNCTION
% -----------------------------

% Maximize the total number of plated coins.
solve maximize TotalCoins;


% -----------------------------
% 5) OUTPUT
% -----------------------------

% Print the number of times each process runs and the total plated coins.
output [
    "Optimal Process Execution:\n",
    "  Process A Runs: ", show(ProcessA), "\n",
    "  Process B Runs: ", show(ProcessB), "\n",
    "Maximum Coins Plated: ", show(TotalCoins), "\n"
];