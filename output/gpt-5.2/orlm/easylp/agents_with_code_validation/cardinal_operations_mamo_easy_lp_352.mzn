% Departments: 1=X, 2=Y, 3=Z, 4=W
set of int: DEPTS = 1..4;

% Limits and minimum requirements
int: max_XY = 100;        % X + Y <= 100
int: max_ZW = 80;         % Z + W <= 80
int: min_XZ = 50;         % X + Z >= 50
int: min_YW = 60;         % Y + W >= 60

% Use scaled integer costs to avoid float linear issues in Gecode
% Costs: X=0.2, Y=0.3, Z=0.1, W=0.4 => multiply by 10
array[DEPTS] of int: cost10 = [2, 3, 1, 4];

% Decision variables: integer allocations (nonnegative) with safe upper bounds
array[DEPTS] of var 0..100: alloc;

% Total cost scaled by 10 (integer)
var 0..(10*100*4): total_cost10;

% Constraints
constraint alloc[1] + alloc[2] <= max_XY;   % X + Y <= 100
constraint alloc[3] + alloc[4] <= max_ZW;   % Z + W <= 80
constraint alloc[1] + alloc[3] >= min_XZ;   % X + Z >= 50
constraint alloc[2] + alloc[4] >= min_YW;   % Y + W >= 60

% Total cost definition (scaled)
constraint total_cost10 = sum(d in DEPTS)(cost10[d] * alloc[d]);

% Objective (minimize true cost, equivalent to minimizing scaled cost)
solve minimize total_cost10;

% Ceiling of true cost:
% true_cost = total_cost10 / 10
% ceil(true_cost) = (total_cost10 + 9) div 10  for nonnegative integers
output [
  "alloc_X=", show(alloc[1]), "\n",
  "alloc_Y=", show(alloc[2]), "\n",
  "alloc_Z=", show(alloc[3]), "\n",
  "alloc_W=", show(alloc[4]), "\n",
  "total_cost10=", show(total_cost10), "\n",
  "total_cost=", show(total_cost10), "/10\n",
  "total_cost_ceil=", show((total_cost10 + 9) div 10), "\n"
];