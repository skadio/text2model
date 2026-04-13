% Parameters
int: nP = 3;
set of int: P = 1..nP;
array[P] of int: proteinP = [23, 20, 8];          % grams protein per 100g
array[P] of int: costP_cents = [300, 500, 150];   % cost in cents per 100g

int: nV = 5;
set of int: V = 1..nV;
array[V] of int: proteinV_tenths = [28, 9, 29, 10, 31]; % tenths of grams protein per 100g pack
array[V] of int: costV_cents = [120, 80, 150, 100, 200]; % cost in cents per 100g pack

int: budget_cents = 2000;
int: maxWeight_g = 800;

% Variables
array[P] of var 0..8: xP;        % number of 100g units of each protein (0..8 due to weight cap)
array[V] of var 0..8: xV;        % number of 100g packs of each vegetable (0..8 due to weight cap)
array[V] of var 0..1: useV;      % whether vegetable type is selected (at least one pack)

var 0..(budget_cents): totalCost_cents;
var 0..maxWeight_g: totalWeight_g;
var 0..(10 * (23*8 + 20*8 + 8*8) + (28*8 + 9*8 + 29*8 + 10*8 + 31*8)): totalProtein_tenths;

% Constraints
constraint totalCost_cents = sum(i in P)(costP_cents[i] * xP[i]) + sum(j in V)(costV_cents[j] * xV[j]);
constraint totalCost_cents <= budget_cents;

constraint totalWeight_g = 100 * (sum(i in P)(xP[i]) + sum(j in V)(xV[j]));
constraint totalWeight_g <= maxWeight_g;

constraint forall(j in V)(
  xV[j] >= useV[j] /\
  xV[j] <= 8 * useV[j]
);
constraint sum(j in V)(useV[j]) >= 3;

constraint totalProtein_tenths =
  sum(i in P)(10 * proteinP[i] * xP[i]) + sum(j in V)(proteinV_tenths[j] * xV[j]);

% Objective
solve maximize totalProtein_tenths;