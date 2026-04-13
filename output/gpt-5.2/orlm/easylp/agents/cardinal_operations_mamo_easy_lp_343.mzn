% Parameters
int: n_routes = 4;                          % number of routes
set of int: ROUTES = 1..n_routes;           % route index set (1=x1,2=x2,3=x3,4=x4)

array[ROUTES] of int: cost = [5, 4, 6, 7];  % operational cost per vehicle on each route

array[ROUTES] of int: lb = [0, 0, 0, 0];    % minimum vehicles per route
array[ROUTES] of int: ub = [50, 40, 60, 70];% maximum vehicles per route

int: cap12 = 20;                            % x1 + x2 <= 20
int: cap34 = 30;                            % x3 + x4 <= 30
int: min13 = 15;                            % x1 + x3 >= 15
int: min24 = 10;                            % x2 + x4 >= 10


% Variables
array[ROUTES] of var int: x;                % vehicles assigned to each route (x[1]=x1,...,x[4]=x4)
var int: total_cost;                        % total operational cost


% Constraints
% Fleet size bounds per route (feasibility)
constraint
  forall(r in ROUTES) (
    lb[r] <= x[r] /\ x[r] <= ub[r]
  );

% Capacity limits on paired routes (traffic/capacity regulations)
constraint
  x[1] + x[2] <= cap12;
constraint
  x[3] + x[4] <= cap34;

% Minimum coverage requirements on paired routes (service demand)
constraint
  x[1] + x[3] >= min13;
constraint
  x[2] + x[4] >= min24;

% Total operational cost definition
constraint
  total_cost = sum(r in ROUTES) (cost[r] * x[r]);


% Objective
solve minimize total_cost;