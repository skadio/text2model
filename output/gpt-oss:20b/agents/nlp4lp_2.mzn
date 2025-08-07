%  DEC System Production Model
%  ----------------------------
%  All data is provided in a .dzn file.
%  Variables:
%    x[i]   – number of system i to produce (real, fractional production allowed)
%    alt[i] – number of alternative memory boards used for system i
%
%  Constraints:
%    1. Pre‑order fulfillment  : x[i] >= Preorder[i]
%    2. System demand          : x[i] <= Demand[i]
%    3. Family demand limits   : sum(GP) <= DemandGP , sum(WS) <= DemandWS
%    4. CPU availability      : sum(x[i]) <= MaxCpu
%    5. Disk drive limits     : MinDisk <= sum(x[i]*DiskDrives[i]) <= MaxDisk
%    6. Memory board limits   : MinMemory <= sum(x[i]*MemoryBoards[i]-alt[i]) <= MaxMemory
%    7. Alternative memory use: sum(alt[i]) <= AltMemory
%    8. Alternative memory usage only on compatible systems
%
%  Objective: maximise profit = sum(x[i]*Price[i])

include "globals.mzn";

int: N;                                      % number of system types
array[1..N] of bool: IsWorkstation;          % true if workstation
array[1..N] of int:  Price;                  % price of system i
array[1..N] of float: DiskDrives;            % average disk drives per system
array[1..N] of int:   MemoryBoards;          % 256‑K memory boards per system
int: MaxCpu;                                 % maximum CPUs available
float: MinDisk;                              % minimum total disk drives
float: MaxDisk;                              % maximum total disk drives
int: MinMemory;                              % minimum total memory boards
int: MaxMemory;                              % maximum total memory boards
array[1..N] of int: Demand;                  % maximum demand for each system
int: DemandGP;                               % demand for GP family
int: DemandWS;                               % demand for WS family
array[1..N] of int: Preorder;                % pre‑ordered units that must be produced
int: AltMemory;                              % alternative memory board supply
array[1..N] of bool: AltCompatible;          % true if alternative memory can be used

% ----- derived constants ----------------------------------------------------
int: maxDemand = max(max(Demand), max(Preorder));   % upper bound for production
float: maxDemandF = float(maxDemand);

% ----- decision variables ----------------------------------------------------
array[1..N] of var 0.0 .. maxDemandF: x;    % production quantity of system i
array[1..N] of var 0.0 .. maxDemandF: alt; % alternative memory boards used

% ----- constraints ------------------------------------------------------------
constraint
    % 1. Pre‑order fulfillment
    forall(i in 1..N) (x[i] >= float(Preorder[i])) /\
    % 2. System demand limits
    forall(i in 1..N) (x[i] <= float(Demand[i])) /\
    % 3. Family demand limits
    sum(i in 1..N where not IsWorkstation[i]) (x[i]) <= float(DemandGP) /\
    sum(i in 1..N where IsWorkstation[i])     (x[i]) <= float(DemandWS) /\
    % 4. CPU availability
    sum(i in 1..N) (x[i]) <= float(MaxCpu) /\
    % 5. Disk drive limits
    sum(i in 1..N) (x[i] * DiskDrives[i]) >= MinDisk /\
    sum(i in 1..N) (x[i] * DiskDrives[i]) <= MaxDisk /\
    % 6. Memory board limits (standard boards after alternative substitution)
    sum(i in 1..N) (x[i] * float(MemoryBoards[i]) - alt[i]) >= float(MinMemory) /\
    sum(i in 1..N) (x[i] * float(MemoryBoards[i]) - alt[i]) <= float(MaxMemory) /\
    % 7. Alternative memory usage limit
    sum(i in 1..N) (alt[i]) <= float(AltMemory) /\
    % 8. Alternative memory only on compatible systems
    forall(i in 1..N) (
        if AltCompatible[i] then
            alt[i] <= x[i]
        else
            alt[i] == 0.0
        endif
    );

% ----- objective ------------------------------------------------------------
var float: profit = sum(i in 1..N) (x[i] * float(Price[i]));
solve maximize profit;

% ----- output ---------------------------------------------------------------
output [
    "Profit = ", show(profit), "\n",
    "Production quantities:\n",
    concat([ show(i) ++ ": " ++ show(x[i]) ++ "\n" | i in 1..N]), "\n",
    "Alternative memory usage:\n",
    concat([ show(i) ++ ": " ++ show(alt[i]) ++ "\n" | i in 1..N])
];