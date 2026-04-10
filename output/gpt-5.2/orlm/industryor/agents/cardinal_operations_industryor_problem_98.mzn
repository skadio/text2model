% Parameters
int: nComponents = 3;                         % number of component types
set of int: COMPONENT = 1..nComponents;

int: maxSpares = 5;                           % maximum number of spares considered per component
set of int: SPARES = 0..maxSpares;

int: budgetLimit = 150;                       % total budget limit (yuan)
int: weightLimit = 20;                        % total weight limit (kg)

array[COMPONENT] of int: unitPrice = [20, 30, 40];   % unit price per spare (yuan)
array[COMPONENT] of int: unitWeight = [2, 4, 6];     % unit weight per spare (kg)

% reliability[component, spares] = reliability of that component with given number of spares
array[COMPONENT, SPARES] of float: reliability =
[
  % spares:    0     1     2     3     4     5
  | 0.5,  0.6,  0.7,  0.8,  0.9,  1.0   % component 1
  | 0.6,  0.75, 0.95, 1.0,  1.0,  1.0   % component 2
  | 0.7,  0.9,  1.0,  1.0,  1.0,  1.0   % component 3
];

% Variables
array[COMPONENT] of var SPARES: sparesInstalled;     % spares installed for each component type

% Helper variables for linear constraints
var 0..budgetLimit: totalCost;                       % total cost of installed spares (yuan)
var 0..weightLimit: totalWeight;                     % total weight of installed spares (kg)

% Constraints
% --- Total cost computation and budget limit ---
constraint
  totalCost = sum(c in COMPONENT)(unitPrice[c] * sparesInstalled[c]);
constraint
  totalCost <= budgetLimit;

% --- Total weight computation and weight limit ---
constraint
  totalWeight = sum(c in COMPONENT)(unitWeight[c] * sparesInstalled[c]);
constraint
  totalWeight <= weightLimit;

% Objective
solve maximize
  product(c in COMPONENT)(reliability[c, sparesInstalled[c]]);