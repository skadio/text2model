% Parameters (with values embedded)
int: N = 3;                       % number of component types
set of int: C = 1..N;

int: Smax = 5;                    % max number of spares considered (0..5)
set of int: S = 0..Smax;

int: budget = 150;                % yuan
int: weight_limit = 20;           % kg

array[C] of int: price = [20, 30, 40];   % yuan per spare
array[C] of int: weight = [2, 4, 6];     % kg per spare

% Reliability table r[c, s] for component c with s spares installed
% To avoid floating point issues, scale reliabilities by 100:
% e.g., 0.5 -> 50, 1.0 -> 100
int: scale = 100;
array[C, S] of int: rel = 
  [| 50,  60,  70,  80,  90, 100    % component 1, s=0..5
   | 60,  75,  95, 100, 100, 100    % component 2, s=0..5
   | 70,  90, 100, 100, 100, 100 |];% component 3, s=0..5

% Variables
array[C] of var S: spares;         % number of spares chosen for each component

% Constraints
constraint sum(c in C)(price[c] * spares[c]) <= budget;
constraint sum(c in C)(weight[c] * spares[c]) <= weight_limit;

% Objective
% Maximize system reliability = product over components of rel[c, spares[c]].
% Since each rel is scaled by 100, maximizing the product of scaled values
% is equivalent to maximizing the true product.
var int: sys_rel_scaled = product(c in C)(rel[c, spares[c]]);

solve maximize sys_rel_scaled;

output [
  "Spares chosen (component 1..3): ", show([spares[c] | c in C]), "\n",
  "Total cost: ", show(sum(c in C)(price[c] * spares[c])), " yuan\n",
  "Total weight: ", show(sum(c in C)(weight[c] * spares[c])), " kg\n",
  "System reliability (scaled product): ", show(sys_rel_scaled), "\n",
  "System reliability (approx): ", show(float(sys_rel_scaled) / pow(100.0, N)), "\n"
];