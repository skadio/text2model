% Coin plating optimisation model
% --------------------------------

% ---------------------- data ----------------------
int: GoldPerA;      % gold required per run of process A
int: WiresPerA;     % wires required per run of process A
int: CoinsPerA;     % coins produced per run of process A

int: GoldPerB;      % gold required per run of process B
int: WiresPerB;     % wires required per run of process B
int: CoinsPerB;     % coins produced per run of process B

int: TotalGold;     % total available gold
int: TotalWires;    % total available wires
% ---------------------------------------------------

% ------------------ bounds for decision vars --------
int: maxA = min(TotalGold div GoldPerA, TotalWires div WiresPerA);
int: maxB = min(TotalGold div GoldPerB, TotalWires div WiresPerB);

% ------------------ decision variables -------------
var 0..maxA: processA;      % number of times process A is run
var 0..maxB: processB;      % number of times process B is run

% ------------------ derived variable ----------------
var int: totalCoins = CoinsPerA * processA + CoinsPerB * processB;

% ------------------ constraints --------------------
constraint GoldPerA * processA + GoldPerB * processB <= TotalGold;
constraint WiresPerA * processA + WiresPerB * processB <= TotalWires;

% ------------------ objective ----------------------
solve maximize totalCoins;

% ------------------ output -------------------------
output [
  "Process A runs   = ", show(processA), "\n",
  "Process B runs   = ", show(processB), "\n",
  "Total coins made = ", show(totalCoins), "\n"
];