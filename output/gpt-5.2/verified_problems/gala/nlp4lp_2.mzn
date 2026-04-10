% DEC production planning (LP with alternative memory substitution)
% Assumes all parameters are provided in a .dzn file.

int: N;
set of int: SYS = 1..N;

array[SYS] of bool: IsWorkstation;
array[SYS] of float: Price;
array[SYS] of float: DiskDrives;      % average disk drives per system (can be fractional)
array[SYS] of float: MemoryBoards;    % 256K memory boards per system (given as int in data, use float for safety)

float: MaxCpu;

float: MinDisk;
float: MaxDisk;

float: MinMemory;
float: MaxMemory;

array[SYS] of float: Demand;          % max demand per system
array[SYS] of float: Preorder;        % preorder that must be met

float: DemandGP;
float: DemandWS;

float: AltMemory;                    % available alternative memory boards (units)
array[SYS] of bool: AltCompatible;    % alt memory can be used on system i?

%--------------------------
% Decision variables
%--------------------------
array[SYS] of var float: x;           % number of systems i produced (can be fractional)
array[SYS] of var float: altUsed;     % alternative memory units used on system i
array[SYS] of var float: stdUsed;     % standard 256K memory units used on system i

%--------------------------
% Core constraints
%--------------------------
% Demand bounds + preorder fulfillment
constraint forall(i in SYS) (
  x[i] >= Preorder[i] /\ x[i] <= Demand[i]
);

% CPU availability (1 CPU per system)
constraint sum(i in SYS)(x[i]) <= MaxCpu;

% Disk supply bounds (total disk drives)
constraint MinDisk <= sum(i in SYS)(DiskDrives[i] * x[i]) /\
                      sum(i in SYS)(DiskDrives[i] * x[i]) <= MaxDisk;

% Memory accounting: std + alt = required, with compatibility for alt
constraint forall(i in SYS)(
  stdUsed[i] >= 0.0 /\ altUsed[i] >= 0.0 /\
  stdUsed[i] + altUsed[i] = MemoryBoards[i] * x[i] /\
  (if AltCompatible[i] then true else altUsed[i] = 0.0 endif)
);

% Memory supply bounds (standard 256K boards)
constraint MinMemory <= sum(i in SYS)(stdUsed[i]) /\
                      sum(i in SYS)(stdUsed[i]) <= MaxMemory;

% Alternative memory availability
constraint sum(i in SYS)(altUsed[i]) <= AltMemory;

% Family demand caps
constraint sum(i in SYS where not IsWorkstation[i])(x[i]) <= DemandGP;
constraint sum(i in SYS where IsWorkstation[i])(x[i]) <= DemandWS;

%--------------------------
% Objective: maximize revenue (profit not otherwise specified)
%--------------------------
var float: revenue = sum(i in SYS)(Price[i] * x[i]);
solve maximize revenue;

%--------------------------
% Output
%--------------------------
output [
  "Revenue = ", show(revenue), "\n",
  "x (systems produced) = ", show(x), "\n",
  "StandardMemoryUsed = ", show(stdUsed), "\n",
  "AltMemoryUsed = ", show(altUsed), "\n",
  "TotalCPU = ", show(sum(i in SYS)(x[i])), "\n",
  "TotalDisk = ", show(sum(i in SYS)(DiskDrives[i] * x[i])), "\n",
  "TotalStdMemory = ", show(sum(i in SYS)(stdUsed[i])), "\n",
  "TotalAltMemory = ", show(sum(i in SYS)(altUsed[i])), "\n",
  "GP total = ", show(sum(i in SYS where not IsWorkstation[i])(x[i])), "\n",
  "WS total = ", show(sum(i in SYS where IsWorkstation[i])(x[i])), "\n"
];