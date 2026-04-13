% Forest Paper production planning (maximize profit)
% Data embedded as requested.

% To avoid fractional minutes/profits, scale everything by 2.
% Time units: 0.5 minutes. Profit units: $0.5.

int: avail = 350 * 2;              % 700 half-minutes available per machine per day

int: tPrintGraph = 3 * 2;          % 6 half-minutes per ream
int: tScanGraph  = 5.5 * 2;        % 11 half-minutes per ream

int: tPrintMusic = 1.5 * 2;        % 3 half-minutes per ream
int: tScanMusic  = 3 * 2;          % 6 half-minutes per ream

int: pGraph = 4 * 2;               % 8 half-dollars per ream
int: pMusic = 2.5 * 2;             % 5 half-dollars per ream

% Decision variables: number of reams (nonnegative integers)
var 0..avail div min(tPrintGraph, tPrintMusic): graph;
var 0..avail div min(tPrintGraph, tPrintMusic): music;

% Machine capacity constraints
constraint tPrintGraph * graph + tPrintMusic * music <= avail;  % printing time
constraint tScanGraph  * graph + tScanMusic  * music <= avail;  % scanning time

% Objective: maximize total profit (in half-dollars)
var 0..1000000: profit2 = pGraph * graph + pMusic * music;

solve maximize profit2;

output [
  "Graph reams = ", show(graph), "\n",
  "Music reams = ", show(music), "\n",
  "Profit = $", show(profit2 div 2), if profit2 mod 2 = 1 then ".5" else ".0" endif, "\n"
];