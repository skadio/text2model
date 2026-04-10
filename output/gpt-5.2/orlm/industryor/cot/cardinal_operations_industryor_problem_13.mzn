% Parameters (with values embedded)
int: Np = 3; % proteins
int: Nv = 5; % vegetables
set of int: P = 1..Np;
set of int: V = 1..Nv;

% Data per 100g unit
array[P] of int: protP = [23, 20, 8];          % grams protein
array[P] of int: costP_cents = [300, 500, 150]; % cost in cents

array[V] of int: protV_tenths = [28, 9, 29, 10, 31]; % protein in tenths of grams
array[V] of int: costV_cents  = [120, 80, 150, 100, 200];

int: budget_cents = 2000; % $20
int: max_weight_g = 800;

% Variables
% quantities in 100g units (integer); max units limited by weight
array[P] of var 0..8: xP;  % protein quantities (each unit = 100g)
array[V] of var 0..8: xV;  % vegetable pack counts (each pack = 100g)

% whether at least one pack of each vegetable is chosen
array[V] of var bool: useV;

% Constraints
constraint
  sum(p in P)(xP[p]) + sum(v in V)(xV[v]) <= max_weight_g div 100;

constraint
  sum(p in P)(costP_cents[p] * xP[p]) + sum(v in V)(costV_cents[v] * xV[v]) <= budget_cents;

% link useV to vegetable selection
constraint
  forall(v in V)(useV[v] <-> (xV[v] >= 1));

% at least three different vegetable types
constraint
  sum(v in V)(bool2int(useV[v])) >= 3;

% Objective
% maximize total protein, scaled to tenths of grams to keep everything integral
var int: total_protein_tenths =
    10 * sum(p in P)(protP[p] * xP[p])
  +      sum(v in V)(protV_tenths[v] * xV[v]);

solve maximize total_protein_tenths;