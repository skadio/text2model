% Parameters
% Coefficients and bounds from the problem statement
int: a11 = 10;         % Coefficient of X1 in machine capacity constraint
int: a12 = 15;         % Coefficient of X2 in machine capacity constraint
int: cap = 2000;       % Machine capacity upper bound

int: a21 = 12;         % Coefficient of X1 in minimum productivity constraint
int: a22 = 6;          % Coefficient of X2 in minimum productivity constraint
int: min_prod = 800;   % Minimum productivity lower bound

int: diff_bound = 100; % Bound on (X1 - 0.5 * X2)

int: cost1 = 50;       % Cost per unit of X1
int: cost2 = 75;       % Cost per unit of X2

% Derived bounds for decision variables (tight non-negative upper bounds)
int: x1_ub = cap div a11;  % From 10*X1 <= 2000
int: x2_ub = cap div a12;  % From 15*X2 <= 2000


% Variables
var 0..x1_ub: x1;  % Units produced of product X1 (integer, non-negative)
var 0..x2_ub: x2;  % Units produced of product X2 (integer, non-negative)

% Total production cost (bounded for better propagation)
var 0..(cost1 * x1_ub + cost2 * x2_ub): total_cost;


% Constraints
% --- Machine capacity (upper bound) ---
constraint a11 * x1 + a12 * x2 <= cap;

% --- Minimum productivity (lower bound) ---
constraint a21 * x1 + a22 * x2 >= min_prod;

% --- Balanced production line: avoid fractions by multiplying by 2 ---
% x1 - 0.5*x2 <= diff_bound  <=>  2*x1 - x2 <= 2*diff_bound
constraint 2 * x1 - x2 <= 2 * diff_bound;

% --- Define total cost ---
constraint total_cost = cost1 * x1 + cost2 * x2;


% Objective
solve minimize total_cost;