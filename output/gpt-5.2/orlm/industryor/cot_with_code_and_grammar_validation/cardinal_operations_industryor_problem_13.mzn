% Parameters
int: nP = 3;
set of int: P = 1..nP;
array[P] of int: protP = [23, 20, 8];          % grams protein per 100g
array[P] of int: costP_cents = [300, 500, 150]; % cost per 100g in cents

int: nV = 5;
set of int: V = 1..nV;
array[V] of int: protV_tenths = [28, 9, 29, 10, 31];   % tenths of grams protein per 100g pack
array[V] of int: costV_cents = [120, 80, 150, 100, 200]; % cost per 100g pack in cents

int: budget_cents = 2000;   % $20
int: maxWeight_g = 800;

int: unitWeight_g = 100;    % all quantities in 100g units
int: maxUnits = maxWeight_g div unitWeight_g; % 8

% Variables
array[P] of var 0..maxUnits: xP;     % number of 100g units of each protein
array[V] of var 0..maxUnits: xV;     % number of 100g packs of each vegetable
array[V] of var bool: useV;

var 0..(100*maxUnits*max(0, max(protP)) + 10*maxUnits*max(0, max(protV_tenths))): totalProtein_tenths;
var 0..budget_cents: totalCost_cents;
var 0..maxUnits: totalUnits;

% Constraints
constraint totalUnits = sum(p in P)(xP[p]) + sum(v in V)(xV[v]);
constraint totalUnits * unitWeight_g <= maxWeight_g;

constraint totalCost_cents =
  sum(p in P)(costP_cents[p] * xP[p]) + sum(v in V)(costV_cents[v] * xV[v]);
constraint totalCost_cents <= budget_cents;

constraint forall(v in V)(
  useV[v] <-> (xV[v] >= 1)
);
constraint sum(v in V)(bool2int(useV[v])) >= 3;

constraint totalProtein_tenths =
  sum(p in P)(10 * protP[p] * xP[p]) + sum(v in V)(protV_tenths[v] * xV[v]);

% Objective
solve maximize totalProtein_tenths;