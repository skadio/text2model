% Parameters
int: n_products = 4;                 % number of products (X1..X4)
set of int: P = 1..n_products;       % product index set

array[P] of int: unit_cost = [10, 12, 20, 15]; % cost per unit for X1..X4

% Production bounds for each product (inclusive)
array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [600, 500, 400, 300];

% Constraint right-hand sides
int: cap_x1_x2 = 1000;        % X1 + X2 <= 1000
int: cap_2x1_x3 = 1500;       % 2*X1 + X3 <= 1500
int: dem_3x2_2x4 = 1200;      % 3*X2 + 2*X4 >= 1200
int: max_diff_x3_x4 = 500;    % |X3 - X4| <= 500

% Named indices for clarity
int: X1 = 1;
int: X2 = 2;
int: X3 = 3;
int: X4 = 4;

% Variables
array[P] of var int: x;  % production quantities for X1..X4 (integers)

% Constraints
% ---------------------------------------------------------------------------
% Production bounds (inclusive) for each product
% ---------------------------------------------------------------------------
constraint forall(p in P) (x[p] >= lb[p]);
constraint forall(p in P) (x[p] <= ub[p]);

% ---------------------------------------------------------------------------
% Raw material limitation: X1 + X2 <= 1000
% ---------------------------------------------------------------------------
constraint x[X1] + x[X2] <= cap_x1_x2;

% ---------------------------------------------------------------------------
% Machine capacity restriction: 2*X1 + X3 <= 1500
% ---------------------------------------------------------------------------
constraint 2 * x[X1] + x[X3] <= cap_2x1_x3;

% ---------------------------------------------------------------------------
% Demand requirement: 3*X2 + 2*X4 >= 1200
% ---------------------------------------------------------------------------
constraint 3 * x[X2] + 2 * x[X4] >= dem_3x2_2x4;

% ---------------------------------------------------------------------------
% Balanced product mix: |X3 - X4| <= 500
% ---------------------------------------------------------------------------
constraint abs(x[X3] - x[X4]) <= max_diff_x3_x4;

% Objective
solve minimize sum(p in P) (unit_cost[p] * x[p]);