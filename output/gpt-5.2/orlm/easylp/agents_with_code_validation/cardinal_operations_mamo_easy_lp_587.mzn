% Parameters
int: nProjects = 4;                         % Number of projects
set of int: PROJECTS = 1..nProjects;        % Project index set

array[PROJECTS] of int: unitCost = [60, 50, 70, 80];  % Cost per unit for X1..X4

array[PROJECTS] of int: lb = [0, 0, 0, 0];            % Lower bounds for X1..X4
array[PROJECTS] of int: ub = [400, 350, 250, 150];    % Upper bounds for X1..X4

int: cap12 = 500;                          % X1 + X2 <= 500
int: cap34 = 300;                          % X3 + X4 <= 300
int: min13 = 200;                          % X1 + X3 >= 200
int: minStrategic = 100;                   % X2 - 0.5*X4 >= 100  <=>  2*X2 - X4 >= 200


% Variables
array[PROJECTS] of var int: x;             % Investment in each project (X1..X4), integer units
var int: totalCost;                        % Total cost to minimize


% Constraints

% --- Bounds on each project's investment (integrality implied by var int) ---
constraint
  forall(p in PROJECTS) (
    lb[p] <= x[p] /\ x[p] <= ub[p]
  );

% --- Budget/technical capacity constraints on grouped projects ---
constraint
  x[1] + x[2] <= cap12;   % X1 + X2 cannot exceed 500

constraint
  x[3] + x[4] <= cap34;   % X3 + X4 cannot exceed 300

% --- Minimum diversification constraint ---
constraint
  x[1] + x[3] >= min13;   % X1 + X3 must be at least 200

% --- Strategic constraint (avoid fractional coefficient by scaling) ---
constraint
  2 * x[2] - x[4] >= 2 * minStrategic;  % X2 - 0.5*X4 >= 100  <=>  2*X2 - X4 >= 200

% --- Define total cost consistently with unit costs ---
constraint
  totalCost = sum(p in PROJECTS) (unitCost[p] * x[p]);


% Objective
solve minimize totalCost;