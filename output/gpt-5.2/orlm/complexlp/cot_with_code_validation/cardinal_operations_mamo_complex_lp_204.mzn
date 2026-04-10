% Fertilizer blending to meet target chemical percentages at minimum cost

int: F = 5;
set of int: Fert = 1..F;
set of int: Chem = 1..3; % 1=Ni, 2=Ph, 3=Po

array[Chem] of float: target = [10.0, 8.0, 12.0];
float: tol = 0.5;

% Percent composition for each fertilizer (in percent, not fractions)
array[Fert, Chem] of float: pct =
  [| 10.0,  8.0, 12.0,   % Fert 1
      8.0, 11.0, 15.0,   % Fert 2
     12.0,  7.0, 12.0,   % Fert 3
     10.0, 10.0, 10.0,   % Fert 4
     15.0, 10.0,  6.0 |];% Fert 5

% Cost per 100 pounds
array[Fert] of float: cost100 = [21.75, 23.50, 22.00, 19.50, 18.50];

% Convert to cost per pound
array[Fert] of float: cost1 = [ cost100[i] / 100.0 | i in Fert ];

% Variables: blend fractions by weight (sum to 1)
array[Fert] of var float: x;
var float: cost_per_lb;

constraint forall(i in Fert) (x[i] >= 0.0);
constraint sum(i in Fert)(x[i]) = 1.0;

% Composition bounds: target <= blend <= target + tol (each in percent)
constraint forall(k in Chem)(
  sum(i in Fert)(x[i] * pct[i,k]) >= target[k] /\
  sum(i in Fert)(x[i] * pct[i,k]) <= target[k] + tol
);

% Cost definition
constraint cost_per_lb = sum(i in Fert)(x[i] * cost1[i]);

solve minimize cost_per_lb;

output [
  "cost_per_lb=", show(cost_per_lb), "\n",
  "x=", show(x), "\n"
];