% Spare parts allocation to maximize system reliability
% Data embedded directly in the model.

int: nComp = 3;
set of int: COMP = 1..nComp;

int: maxSpares = 5;
set of int: SPARES = 0..maxSpares;

% Reliability table: rel[spares, component]
array[SPARES, COMP] of float: rel =
  [| 0.5, 0.6, 0.7  % 0 spares
   | 0.6, 0.75, 0.9 % 1 spare
   | 0.7, 0.95, 1.0 % 2 spares
   | 0.8, 1.0, 1.0  % 3 spares
   | 0.9, 1.0, 1.0  % 4 spares
   | 1.0, 1.0, 1.0  % 5 spares
  |];

array[COMP] of int: price = [20, 30, 40]; % yuan per spare
array[COMP] of int: weight = [2, 4, 6];   % kg per spare

int: budgetLimit = 150;
int: weightLimit = 20;

array[COMP] of var SPARES: s; % number of spares chosen for each component type

constraint sum(c in COMP)(price[c] * s[c]) <= budgetLimit;
constraint sum(c in COMP)(weight[c] * s[c]) <= weightLimit;

% Maximize product of reliabilities via maximizing sum of logs.
% Since rel can be 1.0, log(1)=0 is fine.
array[SPARES, COMP] of float: logrel =
  array2d(SPARES, COMP, [ ln(rel[k,c]) | k in SPARES, c in COMP ]);

var float: obj = sum(c in COMP)( logrel[s[c], c] );

solve maximize obj;

output [
  "Spares chosen (component 1..3): ", show([s[c] | c in COMP]), "\n",
  "Total cost: ", show(sum(c in COMP)(price[c] * s[c])), " yuan\n",
  "Total weight: ", show(sum(c in COMP)(weight[c] * s[c])), " kg\n",
  "Component reliabilities: ",
    show([rel[fix(s[c]), c] | c in COMP]), "\n",
  "System reliability (product): ",
    show( rel[fix(s[1]),1] * rel[fix(s[2]),2] * rel[fix(s[3]),3] ), "\n"
];