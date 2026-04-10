% Parameters
% Revenue/cost coefficients per unit cargo for each ship (embedded from description)
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% Capacity limits (embedded from description)
int: cap12 = 1000;  % x1 + x2 <= 1000
int: cap34 = 800;   % x3 + x4 <= 800

% Contract requirements (embedded from description)
int: req12 = 300;   % (1/2)x1 + (1/4)x2 >= 300
int: req34 = 250;   % (3/4)x3 + (3/5)x4 >= 250


% Variables
% Loads are whole numbers (integer decision variables), non-negative
var 0..cap12: x1;  % load on ship 1
var 0..cap12: x2;  % load on ship 2
var 0..cap34: x3;  % load on ship 3
var 0..cap34: x4;  % load on ship 4

% Total cost (upper bound derived from max loads)
var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;


% Constraints
% --- Capacity constraints ---
constraint x1 + x2 <= cap12;  % port limitation for ships 1 and 2
constraint x3 + x4 <= cap34;  % operating limitation for ships 3 and 4

% --- Contract requirement constraints (scaled to avoid fractions) ---
% (1/2)x1 + (1/4)x2 >= req12  <=>  2*x1 + x2 >= 4*req12
constraint 2 * x1 + x2 >= 4 * req12;

% (3/4)x3 + (3/5)x4 >= req34  <=>  15*x3 + 12*x4 >= 20*req34
constraint 15 * x3 + 12 * x4 >= 20 * req34;

% --- Total cost definition ---
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_cost;