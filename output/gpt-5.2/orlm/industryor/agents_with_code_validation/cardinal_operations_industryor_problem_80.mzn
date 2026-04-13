% Parameters
int: nCars = 15;                                  % number of cars
set of int: CARS = 1..nCars;

array[CARS] of float: len =                        % car lengths (meters)
  [ 4.0, 4.5, 5.0, 4.1, 2.4, 5.2, 3.7, 3.5, 3.2, 4.5, 2.3, 3.3, 3.8, 4.6, 3.0 ];

int: nSides = 2;                                   % two sides of the street
set of int: SIDES = 1..nSides;

float: sideMax = 30.0;                             % max allowed on one side (set to 30.0 for the variant)
float: totalLen = sum(c in CARS)(len[c]);          % total length of all cars
float: lbSide = totalLen / 2.0;                    % lower bound on the maximum side load
float: ubSide = totalLen;                          % upper bound on the maximum side load

% Variables
array[CARS] of var SIDES: side;                    % side assignment for each car (1 or 2)

var float: sideLen1;                               % total length on side 1
var float: sideLen2;                               % total length on side 2

var float: maxSideLen;                             % street length needed = max(sideLen1, sideLen2)

% Constraints
% --- Side load definitions (compute total occupied length per side) ---
constraint
  sideLen1 = sum(c in CARS)(len[c] * int2float(bool2int(side[c] = 1)));

constraint
  sideLen2 = sum(c in CARS)(len[c] * int2float(bool2int(side[c] = 2)));

% --- Maximum side length linking (street length needed is the max of both sides) ---
constraint
  maxSideLen >= sideLen1;

constraint
  maxSideLen >= sideLen2;

% --- Bounds tightening for maxSideLen (helps propagation) ---
constraint
  maxSideLen >= lbSide;

constraint
  maxSideLen <= ubSide;

% --- Variant: capacity limit per side (set sideMax=30.0 to enforce) ---
constraint
  sideLen1 <= sideMax;

constraint
  sideLen2 <= sideMax;

% Objective
solve minimize maxSideLen;