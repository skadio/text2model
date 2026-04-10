% Bomber planning to maximize probability of destroying at least 2 of 4 parts
% Data embedded as requested.

include "globals.mzn";

int: N = 4;

set of int: PARTS = 1..N;

% Distances from airport (km)
array[PARTS] of int: dist = [450, 480, 540, 600];

% Per-bomb destruction probabilities
array[PARTS] of float: pH = [0.03, 0.10, 0.05, 0.05];
array[PARTS] of float: pL = [0.08, 0.11, 0.12, 0.09];

% Resource limits
int: maxHeavy = 28;
int: maxLight = 12;
int: maxFuel  = 10000;

% Flight/fuel rules
% - One bomb per trip.
% - Takeoff+landing fixed fuel per trip: 100 liters.
% - Outbound range: with heavy bomb, 1 liter gives 2 km; with light, 3 km.
% - Return empty: 1 liter gives 4 km.
%
% Fuel per trip to part i:
%   Heavy: 100 + dist[i]/2 + dist[i]/4 = 100 + 0.75*dist[i]
%   Light: 100 + dist[i]/3 + dist[i]/4 = 100 + (7/12)*dist[i]
array[PARTS] of float: fuelH = [100.0 + 0.75 * float(dist[i]) | i in PARTS];
array[PARTS] of float: fuelL = [100.0 + (7.0/12.0) * float(dist[i]) | i in PARTS];

% Decisions: number of heavy/light bomb trips assigned to each part
array[PARTS] of var 0..maxHeavy: xH;
array[PARTS] of var 0..maxLight: xL;

% Stockpile constraints
constraint sum(i in PARTS)(xH[i]) <= maxHeavy;
constraint sum(i in PARTS)(xL[i]) <= maxLight;

% Fuel constraint (use scaling to avoid float vars in constraints)
% Scale by 1000 to preserve 3 decimals.
int: SCALE = 1000;
array[PARTS] of int: fuelH_sc = [round(fuelH[i] * SCALE) | i in PARTS];
array[PARTS] of int: fuelL_sc = [round(fuelL[i] * SCALE) | i in PARTS];
int: maxFuel_sc = maxFuel * SCALE;

constraint sum(i in PARTS)( fuelH_sc[i] * xH[i] + fuelL_sc[i] * xL[i] ) <= maxFuel_sc;

% Objective: maximize probability of destroying at least 2 parts.
% Assume independence between parts and between bombs; multiple bombs on a part:
%   P(part i destroyed) = 1 - (1-pH[i])^xH[i] * (1-pL[i])^xL[i]
array[PARTS] of var float: q;          % q[i] = P(part i destroyed)
constraint forall(i in PARTS)(
  q[i] = 1.0
         - pow(1.0 - pH[i], int2float(xH[i]))
         * pow(1.0 - pL[i], int2float(xL[i]))
);

% Enumerate all subsets of size >= 2 to compute P(#destroyed >= 2)
% For subset S: P(exactly S destroyed) = prod(i in S) q[i] * prod(i notin S) (1-q[i])
set of set of int: good =
  { s | s subset PARTS where card(s) >= 2 };

var float: Psuccess =
  sum(s in good)(
    product(i in s)(q[i]) * product(i in PARTS diff s)(1.0 - q[i])
  );

solve maximize Psuccess;

output [
  "Heavy trips per part xH = ", show(xH), "\n",
  "Light trips per part xL = ", show(xL), "\n",
  "Fuel used (liters) = ",
    show( (sum(i in PARTS)( fuelH_sc[i] * xH[i] + fuelL_sc[i] * xL[i] )) / SCALE ),
    "\n",
  "Per-part destruction probabilities q = ", show(q), "\n",
  "Max success probability (>=2 parts destroyed) = ", show(Psuccess), "\n"
];