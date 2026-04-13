% Electronic system spare-parts reliability optimization (3 components)

% Parameters
int: nComponents = 3;
set of int: COMPONENT = 1..nComponents;

int: maxSpares = 5;
set of int: SPARES = 0..maxSpares;

int: budgetLimit = 150;
int: weightLimit = 20;

array[COMPONENT] of int: unitPrice  = [20, 30, 40];
array[COMPONENT] of int: unitWeight = [2, 4, 6];

% reliability[c, s] where s in 0..5
array[COMPONENT, SPARES] of float: reliability =
array2d(COMPONENT, SPARES, [
  0.5, 0.6,  0.7,  0.8,  0.9,  1.0,   % component 1
  0.6, 0.75, 0.95, 1.0,  1.0,  1.0,   % component 2
  0.7, 0.9,  1.0,  1.0,  1.0,  1.0    % component 3
]);

% Decision variables
array[COMPONENT] of var SPARES: sparesInstalled;

% Use scaled integers to avoid non-linear float decision expressions
% scale = 100 (e.g., 0.75 -> 75)
int: scale = 100;
array[COMPONENT, SPARES] of int: relScaled =
array2d(COMPONENT, SPARES, [
  50, 60, 70, 80, 90, 100,
  60, 75, 95, 100, 100, 100,
  70, 90, 100, 100, 100, 100
]);

array[COMPONENT] of var 0..scale: compRelScaled;
var int: systemRelScaled; % scaled by scale^nComponents

% Constraints
constraint forall(c in COMPONENT) (
  compRelScaled[c] = relScaled[c, sparesInstalled[c]]
);

constraint sum(c in COMPONENT) (unitPrice[c] * sparesInstalled[c]) <= budgetLimit;
constraint sum(c in COMPONENT) (unitWeight[c] * sparesInstalled[c]) <= weightLimit;

constraint systemRelScaled = prod(c in COMPONENT) (compRelScaled[c]);

% Objective: maximize system reliability (scaled)
solve maximize systemRelScaled;

output [
  "sparesInstalled = ", show(sparesInstalled), "\n",
  "componentReliability = [",
    concat([ if c > 1 then ", " else "" endif ++
             show(relScaled[c, sparesInstalled[c]] / 100.0)
           | c in COMPONENT ]),
  "]\n",
  "systemReliability = ",
    show(systemRelScaled / (pow(scale, nComponents) * 1.0)),
  "\n",
  "totalCost = ", show(sum(c in COMPONENT) (unitPrice[c] * sparesInstalled[c])), "\n",
  "totalWeight = ", show(sum(c in COMPONENT) (unitWeight[c] * sparesInstalled[c])), "\n"
];