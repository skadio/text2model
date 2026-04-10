% Parameters (with values embedded)
int: G = 3;
int: N = 4;
set of int: Grains = 1..G;
set of int: Nutrients = 1..N;

% Nutrients indexed as: 1=A, 2=B, 3=C, 4=D
array[Grains, Nutrients] of float: nutr_per_lb =
  [| 20.0, 10.0, 50.0,  6.0   % Grain 1
   | 30.0, 10.0, 30.0,  2.5   % Grain 2
   | 70.0,  0.0,  0.0, 10.0 | % Grain 3
  ];

array[Nutrients] of float: min_req = [110.0, 18.0, 90.0, 14.0];

array[Grains] of float: cost_cents_per_lb = [41.0, 36.0, 96.0];

% Variables
array[Grains] of var float: x; % pounds of each grain per day

% Constraints
constraint forall(g in Grains) (x[g] >= 0.0);

constraint forall(n in Nutrients) (
  sum(g in Grains) (nutr_per_lb[g,n] * x[g]) >= min_req[n]
);

% Objective
solve minimize sum(g in Grains) (cost_cents_per_lb[g] * x[g]);