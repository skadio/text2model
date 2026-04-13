% Parameters

% Cargo weight contribution (tons) per ship unit
int: wA = 2;
int: wB = 3;
int: wC = 4;

% Cargo volume contribution (m^3) per ship unit
int: vA = 3;
int: vB = 2;
int: vC = 1;

% Minimum total weight requirement (tons)
int: minWeight = 2000;

% Maximum total volume limit (m^3)
int: maxVolume = 3000;

% Minimum difference requirement between ShipA and ShipB units
int: minAminusB = 500;

% Operational cost per ship unit ($)
int: costA = 7;
int: costB = 6;
int: costC = 5;

% A safe upper bound for ship counts derived from volume constraint
% (since all volumes are >= 1, total units can't exceed maxVolume)
int: maxShips = maxVolume;


% Variables

% Number of ships of each type (integer, nonnegative, bounded)
var 0..maxShips: numShipA;
var 0..maxShips: numShipB;
var 0..maxShips: numShipC;

% Total cost to minimize ($), bounded
var 0..(costA*maxShips + costB*maxShips + costC*maxShips): totalCost;


% Constraints

% --- Total weight requirement (at least minWeight tons) ---
constraint
  wA * numShipA + wB * numShipB + wC * numShipC >= minWeight;

% --- Total volume restriction (at most maxVolume m^3) ---
constraint
  vA * numShipA + vB * numShipB + vC * numShipC <= maxVolume;

% --- Difference requirement: ShipA must exceed ShipB by at least minAminusB units ---
constraint
  numShipA - numShipB >= minAminusB;

% --- Define total operational cost from ship counts and unit costs ---
constraint
  totalCost = costA * numShipA + costB * numShipB + costC * numShipC;


% Objective
solve minimize totalCost;