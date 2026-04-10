% Parameters
int: nRoutes = 4;                           % Number of routes
set of int: ROUTES = 1..nRoutes;            % Route index set: 1=X1, 2=X2, 3=X3, 4=X4

array[ROUTES] of int: cost = [4, 5, 6, 7];  % Cost per truck on each route (X1..X4)

int: max_X1_X2 = 50;                        % Upper bound on X1 + X2
int: max_X3_X4 = 80;                        % Upper bound on X3 + X4
int: min_X1_X3 = 30;                        % Lower bound on X1 + X3
int: min_X2_X4 = 40;                        % Lower bound on X2 + X4

% Variables
array[ROUTES] of var 0..80: x;              % x[r] = number of trucks assigned to route r (integer, nonnegative)
var int: total_cost;                        % Total cost (to be minimized)

% Constraints
% --- Route capacity/limit constraints ---
constraint x[1] + x[2] <= max_X1_X2;        % X1 + X2 cannot exceed 50
constraint x[3] + x[4] <= max_X3_X4;        % X3 + X4 cannot exceed 80

% --- Minimum allocation requirements ---
constraint x[1] + x[3] >= min_X1_X3;        % X1 + X3 at least 30
constraint x[2] + x[4] >= min_X2_X4;        % X2 + X4 at least 40

% --- Total cost definition ---
constraint total_cost = sum(r in ROUTES)(cost[r] * x[r]);

% Objective
solve minimize total_cost;