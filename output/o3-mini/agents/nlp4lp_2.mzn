% DEC Production Planning Model

% ---------- Parameters (supplied in the .dzn file) ----------
int: N;                                     % Number of systems

array[1..N] of bool: IsWorkstation;         % True if system i is a workstation, otherwise GP
array[1..N] of float: Price;                % Price (profit) of system i
array[1..N] of float: DiskDrives;           % Average number of disk drives per system i
array[1..N] of float: MemoryBoards;         % Number of 256K memory boards required per system i

int: MaxCpu;                                % Maximum number of CPUs available (1 CPU per system)
float: MinDisk;                             % Minimum total disk drives available for production
float: MaxDisk;                             % Maximum total disk drives available for production
float: MinMemory;                           % Minimum total conventional memory boards available
float: MaxMemory;                           % Maximum total conventional memory boards available

array[1..N] of float: Demand;               % Maximum estimated demand for system i
float: DemandGP;                            % Maximum demand for the whole GP family
float: DemandWS;                            % Maximum demand for the whole WS family
array[1..N] of float: Preorder;             % Preorder demand that must be fulfilled for system i

float: AltMemory;                           % Total available alternative memory boards
array[1..N] of bool: AltCompatible;         % True if system i can use alternative memory

% ---------- Decision Variables ----------
% For each system i, we decide how many to produce.
% For systems that are alternative memory compatible, production is split between:
%   - prodConv[i]: produced using conventional 256K memory boards
%   - prodAlt[i]: produced using alternative memory boards
% For systems not compatible, prodAlt[i] is forced to 0.
array[1..N] of var 0.0..Demand[1]: prodConv; 
array[1..N] of var 0.0..Demand[1]: prodAlt;

% Note: Total production for system i is:
function var float: production(int: i) = prodConv[i] + prodAlt[i];

% ---------- Constraints ----------
% 1. Meet individual system demand and preorder requirements.
constraint
  forall(i in 1..N) (
    production(i) >= Preorder[i] /\ production(i) <= Demand[i]
  );

% 2. If a system is not alternative memory compatible, no alternative memory can be used.
constraint
  forall(i in 1..N) (
    (not AltCompatible[i]) -> (prodAlt[i] = 0.0)
  );

% 3. CPU availability: Each system consumes 1 CPU.
constraint
  sum(i in 1..N)( production(i) ) <= MaxCpu;

% 4. Disk drives supply: Total disk drives used (average per system * production) must lie within bounds.
constraint
  sum(i in 1..N)( production(i) * DiskDrives[i] ) >= MinDisk / 1.0 /\
  sum(i in 1..N)( production(i) * DiskDrives[i] ) <= MaxDisk;

% 5. Conventional memory boards supply constraints.
constraint
  sum(i in 1..N)( prodConv[i] * MemoryBoards[i] ) >= MinMemory / 1.0 /\
  sum(i in 1..N)( prodConv[i] * MemoryBoards[i] ) <= MaxMemory;

% 6. Alternative memory limitation.
constraint
  sum(i in 1..N)( prodAlt[i] ) <= AltMemory;

% 7. Family demand constraints: Total production for each system family must not exceed its demand.
constraint
  sum(i in 1..N where not IsWorkstation[i])( production(i) ) <= DemandGP;
constraint
  sum(i in 1..N where IsWorkstation[i])( production(i) ) <= DemandWS;

% ---------- Objective ----------
% Maximize total profit.
var float: TotalProfit = sum(i in 1..N)( production(i) * Price[i] );
solve maximize TotalProfit;

% ---------- Output ----------
output [
  "DEC Production Plan\n",
  "-----------------\n",
  "For each system i (1..", show(N), "):\n",
  "  Total production = prodConv + prodAlt\n\n",
  concat([ "System ", show(i), ": Total = " , show(production(i)), 
    " (Conventional = " , show(prodConv[i]), 
    ", Alternative = " , show(prodAlt[i]), ")\n" | i in 1..N ]),
  "\nTotal Profit: ", show(TotalProfit), "\n"
];