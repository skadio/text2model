% Strategic bombing plan (fixed for Gecode float limits)
% Uses integer decision variables and computes success probability in the objective
% with floating-point expressions (no var-float linear constraints).

%----------------------------
% Data (embedded)
%----------------------------
int: nParts = 4;
set of int: PARTS = 1..nParts;

array[PARTS] of int: distance_km = [450, 480, 540, 600];

array[PARTS] of float: pHeavy = [0.03, 0.10, 0.05, 0.05];
array[PARTS] of float: pLight = [0.08, 0.11, 0.12, 0.09];

int: maxHeavyBombs = 28;
int: maxLightBombs = 12;
int: fuelLimit = 10000;

int: kmPerLiterHeavyLoaded = 2;
int: kmPerLiterLightLoaded = 3;
int: kmPerLiterEmpty = 4;

int: takeoffLandingFuelPerTrip = 100;

%----------------------------
% Decision variables
%----------------------------
array[PARTS] of var 0..maxHeavyBombs: heavyBombsToPart;
array[PARTS] of var 0..maxLightBombs: lightBombsToPart;

% Derived totals
var 0..maxHeavyBombs: totalHeavyUsed = sum(p in PARTS)(heavyBombsToPart[p]);
var 0..maxLightBombs: totalLightUsed = sum(p in PARTS)(lightBombsToPart[p]);

% Fuel (integer, computed exactly in liters)
% Fuel per heavy trip to part p:
%   takeoff/landing 100 + outbound (d/2) + return (d/4) = 100 + 3d/4
% Fuel per light trip to part p:
%   takeoff/landing 100 + outbound (d/3) + return (d/4) = 100 + 7d/12
array[PARTS] of int: fuelHeavyPerTrip =
  [ takeoffLandingFuelPerTrip + (3 * distance_km[p]) div 4 | p in PARTS ];
array[PARTS] of int: fuelLightPerTrip =
  [ takeoffLandingFuelPerTrip + (7 * distance_km[p]) div 12 | p in PARTS ];

var 0..fuelLimit: totalFuelUsed =
  sum(p in PARTS)(fuelHeavyPerTrip[p] * heavyBombsToPart[p]
                + fuelLightPerTrip[p] * lightBombsToPart[p]);

constraint totalFuelUsed <= fuelLimit;

% Stockpile limits (already implied by domains, but kept explicit)
constraint totalHeavyUsed <= maxHeavyBombs;
constraint totalLightUsed <= maxLightBombs;

%----------------------------
% Objective: maximize probability that at least 2 parts are destroyed
% We avoid var-float constraints (which trigger Gecode float linear issues).
% For a given assignment, part-destruction probability:
%   P_destroy[p] = 1 - (1-pH)^H * (1-pL)^L
% Let q[p] = 1 - P_destroy[p] = (1-pH)^H * (1-pL)^L
% Success probability (>=2 destroyed out of 4):
%   P = 1 - P(0) - P(1)
%   P(0) = Π q[p]
%   P(1) = Σ ( (1-q[i]) * Π_{j!=i} q[j] )
%----------------------------
function float: q(int: p, int: H, int: L) =
  pow(1.0 - pHeavy[p], float(H)) * pow(1.0 - pLight[p], float(L));

function float: successProb(array[int] of int: H, array[int] of int: L) =
  let {
    float: q1 = q(1, H[1], L[1]),
    float: q2 = q(2, H[2], L[2]),
    float: q3 = q(3, H[3], L[3]),
    float: q4 = q(4, H[4], L[4]),
    float: P0 = q1*q2*q3*q4,
    float: P1 = (1.0-q1)*q2*q3*q4
              + q1*(1.0-q2)*q3*q4
              + q1*q2*(1.0-q3)*q4
              + q1*q2*q3*(1.0-q4)
  } in 1.0 - P0 - P1;

solve maximize
  successProb([fix(heavyBombsToPart[p]) | p in PARTS],
              [fix(lightBombsToPart[p]) | p in PARTS]);

%----------------------------
% Output
%----------------------------
output [
  "Heavy bombs per part: ", show([heavyBombsToPart[p] | p in PARTS]), "\n",
  "Light bombs per part: ", show([lightBombsToPart[p] | p in PARTS]), "\n",
  "Total heavy used: ", show(totalHeavyUsed), " / ", show(maxHeavyBombs), "\n",
  "Total light used: ", show(totalLightUsed), " / ", show(maxLightBombs), "\n",
  "Total fuel used: ", show(totalFuelUsed), " / ", show(fuelLimit), "\n",
  "Max success probability (>=2 parts destroyed): ",
  show(successProb([fix(heavyBombsToPart[p]) | p in PARTS],
                   [fix(lightBombsToPart[p]) | p in PARTS])),
  "\n"
];