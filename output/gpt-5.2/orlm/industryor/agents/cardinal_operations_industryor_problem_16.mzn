% Parameters
% Embedded data (no .dzn expected)

int: nParts = 4;                          % number of key parts
set of int: PARTS = 1..nParts;

int: maxHeavyBombs = 28;                  % available heavy bombs
int: maxLightBombs = 12;                  % available light bombs
int: fuelLimit = 10000;                   % total fuel available (liters)

array[PARTS] of int: distKm = [450, 480, 540, 600];          % one-way distance to each part (km)

array[PARTS] of float: pDestroyHeavy = [0.03, 0.10, 0.05, 0.05]; % per-bomb destruction probability (heavy)
array[PARTS] of float: pDestroyLight = [0.08, 0.11, 0.12, 0.09]; % per-bomb destruction probability (light)

int: kmPerLiterHeavy = 2;                  % loaded with heavy bomb: 2 km per liter
int: kmPerLiterLight = 3;                  % loaded with light bomb: 3 km per liter
int: kmPerLiterEmpty = 4;                  % empty aircraft: 4 km per liter
int: takeoffLandingFuel = 100;             % extra fuel per trip (liters)


% Variables
array[PARTS] of var 0..maxHeavyBombs: heavyBombsToPart;      % number of heavy bombs assigned to each part
array[PARTS] of var 0..maxLightBombs: lightBombsToPart;      % number of light bombs assigned to each part

var 0..maxHeavyBombs: totalHeavyUsed;       % total heavy bombs used
var 0..maxLightBombs: totalLightUsed;       % total light bombs used

% Fuel accounting (per bomb = one trip)
% Each trip fuel = takeoffLandingFuel + (loaded one-way) + (empty return)
array[PARTS] of var 0..fuelLimit: fuelForHeavyPart;          % fuel consumed by heavy-bomb trips to each part
array[PARTS] of var 0..fuelLimit: fuelForLightPart;          % fuel consumed by light-bomb trips to each part
var 0..fuelLimit: totalFuelUsed;             % total fuel consumption (liters)

% Success probability modeling via logs
array[PARTS] of var float: logNotDestroyedPart;  % log(P(part i NOT destroyed))
array[PARTS] of var float: qDestroyedPart;       % P(part i destroyed) in [0,1]

var float: probSuccess;                           % P(at least 2 parts destroyed) to maximize


% Constraints

%-------------------------------
% Bomb usage aggregation limits
%-------------------------------
constraint
  totalHeavyUsed = sum(i in PARTS)(heavyBombsToPart[i]);
constraint
  totalLightUsed = sum(i in PARTS)(lightBombsToPart[i]);

constraint
  totalHeavyUsed <= maxHeavyBombs;
constraint
  totalLightUsed <= maxLightBombs;

%-----------------------------------------
% Fuel per trip and total fuel accounting
%-----------------------------------------
% Per-trip fuel (liters) for part i:
%  - loaded one-way: distKm[i] / kmPerLiter{Heavy,Light}
%  - empty return:   distKm[i] / kmPerLiterEmpty
%  - plus takeoff/landing fuel
%
% NOTE: Fuel is modeled in liters as integer. We enforce that the distances
% are divisible by the km/liter rates (true for given data) to avoid coercion.
constraint
  forall(i in PARTS) (
    distKm[i] mod kmPerLiterHeavy = 0 /\
    distKm[i] mod kmPerLiterLight = 0 /\
    distKm[i] mod kmPerLiterEmpty = 0
  );

constraint
  forall(i in PARTS) (
    fuelForHeavyPart[i] =
      heavyBombsToPart[i] * (
        takeoffLandingFuel +
        (distKm[i] div kmPerLiterHeavy) +
        (distKm[i] div kmPerLiterEmpty)
      )
  );

constraint
  forall(i in PARTS) (
    fuelForLightPart[i] =
      lightBombsToPart[i] * (
        takeoffLandingFuel +
        (distKm[i] div kmPerLiterLight) +
        (distKm[i] div kmPerLiterEmpty)
      )
  );

constraint
  totalFuelUsed = sum(i in PARTS)(fuelForHeavyPart[i] + fuelForLightPart[i]);

constraint
  totalFuelUsed <= fuelLimit;

%---------------------------------------------------------
% Per-part destruction probability from assigned bomb loads
%---------------------------------------------------------
% Independence assumption:
% P(part i not destroyed) =
%   (1 - pDestroyHeavy[i])^(heavyBombsToPart[i]) *
%   (1 - pDestroyLight[i])^(lightBombsToPart[i])
%
% In logs:
% logNotDestroyedPart[i] =
%   heavyBombsToPart[i] * ln(1 - pDestroyHeavy[i]) +
%   lightBombsToPart[i] * ln(1 - pDestroyLight[i])
% and qDestroyedPart[i] = 1 - exp(logNotDestroyedPart[i])
constraint
  forall(i in PARTS) (
    logNotDestroyedPart[i] =
      int2float(heavyBombsToPart[i]) * ln(1.0 - pDestroyHeavy[i]) +
      int2float(lightBombsToPart[i]) * ln(1.0 - pDestroyLight[i])
  );

constraint
  forall(i in PARTS) (
    qDestroyedPart[i] = 1.0 - exp(logNotDestroyedPart[i])
  );

%---------------------------------------------------------
% Overall success probability: at least 2 parts destroyed
%---------------------------------------------------------
% With independent parts:
% P(success) = 1 - P(0 destroyed) - P(exactly 1 destroyed)
% where:
% P(0) = Π_i (1 - q_i)
% P(exactly 1) = Σ_k [ q_k * Π_{j!=k} (1 - q_j) ]
constraint
  probSuccess =
    1.0
    - (prod(i in PARTS)(1.0 - qDestroyedPart[i]))
    - (sum(k in PARTS)(
          qDestroyedPart[k] * prod(j in PARTS where j != k)(1.0 - qDestroyedPart[j])
       ));


% Objective
solve maximize probSuccess;