% Parameters
% (All data is embedded directly in this model as requested.)

int: nLocations = 4;                         % Number of locations
set of int: LOC = 1..nLocations;             % Location index set {1..4}

array[LOC] of int: cost = [2, 3, 4, 5];      % Cost per vehicle at each location (X1..X4)

int: cap12 = 500;                            % Upper bound on X1 + X2
int: cap34 = 600;                            % Upper bound on X3 + X4
int: min13 = 300;                            % Lower bound on X1 + X3
int: min24 = 400;                            % Lower bound on X2 + X4

array[LOC] of int: ub = [300, 200, 300, 400];% Upper bounds on each Xi

% Variables
% Use 0..max(ub) as a safe common domain; individual upper bounds enforced by constraints.
array[LOC] of var 0..400: x;                 % Vehicles allocated to each location Xi (integer)
var int: total_cost;                         % Total transportation cost (to minimize)

% Constraints

% --- Capacity constraints between paired locations (upper bounds) ---
constraint x[1] + x[2] <= cap12;             % X1 + X2 cannot exceed 500
constraint x[3] + x[4] <= cap34;             % X3 + X4 cannot exceed 600

% --- Minimum service level constraints between paired locations (lower bounds) ---
constraint x[1] + x[3] >= min13;             % X1 + X3 must be at least 300
constraint x[2] + x[4] >= min24;             % X2 + X4 must be at least 400

% --- Per-location allocation upper bounds ---
constraint forall(i in LOC) (x[i] <= ub[i]); % Each Xi must not exceed its location-specific bound

% --- Define total cost from allocations and per-vehicle costs ---
constraint total_cost = sum(i in LOC) (cost[i] * x[i]);

% Objective
solve minimize total_cost;