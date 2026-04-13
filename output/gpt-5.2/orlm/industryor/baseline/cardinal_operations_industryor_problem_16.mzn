% Strategic bombing plan: choose integer numbers of heavy/light bombs per target part
% to maximize probability that at least 2 of 4 key parts are destroyed.
% All data embedded.

include "float.mzn";

int: N = 4;
set of int: Parts = 1..N;

array[Parts] of int: dist_km = [450, 480, 540, 600];

array[Parts] of float: pH = [0.03, 0.10, 0.05, 0.05];  % per heavy bomb
array[Parts] of float: pL = [0.08, 0.11, 0.12, 0.09];  % per light bomb

int: maxHeavy = 28;
int: maxLight = 12;
int: fuelLimit = 10000; % liters

% Decision variables: number of heavy/light bombs dropped on each part
array[Parts] of var 0..maxHeavy: H;
array[Parts] of var 0..maxLight: L;

constraint sum(Parts)(H[i]) <= maxHeavy;
constraint sum(Parts)(L[i]) <= maxLight;

% Fuel per sortie:
% - outbound loaded: heavy => 2 km/l, light => 3 km/l
% - return empty: 4 km/l
% - plus 100 liters per trip (takeoff+landing)
%
% For part i:
% Heavy trip fuel = dist/2 + dist/4 + 100 = (3/4)*dist + 100
% Light trip fuel = dist/3 + dist/4 + 100 = (7/12)*dist + 100
%
% To avoid fractions, multiply everything by 12:
% Heavy: 12*f = 9*dist + 1200
% Light: 12*f = 7*dist + 1200
int: scale = 12;
int: fuelLimitScaled = fuelLimit * scale;

array[Parts] of int: heavyFuelScaled = [ 9*dist_km[i] + 1200 | i in Parts ];
array[Parts] of int: lightFuelScaled = [ 7*dist_km[i] + 1200 | i in Parts ];

constraint
  sum(Parts)(H[i] * heavyFuelScaled[i] + L[i] * lightFuelScaled[i]) <= fuelLimitScaled;

% Per-part destruction probability after multiple independent bomb attempts:
% q[i] = 1 - (1-pH[i])^H[i] * (1-pL[i])^L[i]
array[Parts] of var float: q;
constraint forall(i in Parts)(
  q[i] = 1.0 - pow(1.0 - pH[i], int2float(H[i])) * pow(1.0 - pL[i], int2float(L[i]))
);

% Overall success probability: at least 2 parts destroyed, assuming independence across parts.
var float: Psuccess;

constraint
  Psuccess =
    % exactly 2 destroyed
    ( q[1]*q[2]*(1.0-q[3])*(1.0-q[4])
    + q[1]*q[3]*(1.0-q[2])*(1.0-q[4])
    + q[1]*q[4]*(1.0-q[2])*(1.0-q[3])
    + q[2]*q[3]*(1.0-q[1])*(1.0-q[4])
    + q[2]*q[4]*(1.0-q[1])*(1.0-q[3])
    + q[3]*q[4]*(1.0-q[1])*(1.0-q[2]) )
    % exactly 3 destroyed
  + ( q[1]*q[2]*q[3]*(1.0-q[4])
    + q[1]*q[2]*q[4]*(1.0-q[3])
    + q[1]*q[3]*q[4]*(1.0-q[2])
    + q[2]*q[3]*q[4]*(1.0-q[1]) )
    % all 4 destroyed
  + ( q[1]*q[2]*q[3]*q[4] );

solve maximize Psuccess;

output [
  "Heavy bombs per part (H): ", show(H), "\n",
  "Light bombs per part (L): ", show(L), "\n",
  "Fuel used (liters): ",
    show( (sum(i in Parts)(H[i] * heavyFuelScaled[i] + L[i] * lightFuelScaled[i])) / scale ),
    " + ", show( (sum(i in Parts)(H[i] * heavyFuelScaled[i] + L[i] * lightFuelScaled[i])) mod scale ),
    "/", show(scale), "\n",
  "Per-part destruction probabilities q: ", show(q), "\n",
  "Max probability of success (>=2 parts destroyed): ", show(Psuccess), "\n"
];