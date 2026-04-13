% Parameters
int: num_furnaces = 2;                 % Number of furnaces available
int: a = 2;                            % Hours per furnace using method 1
int: b = 3;                            % Hours per furnace using method 2
int: m = 50;                           % Fuel cost per furnace for method 1
int: n = 70;                           % Fuel cost per furnace for method 2
int: k = 10;                           % Tons produced per furnace (either method)
int: d = 30;                           % Minimum tons required
int: c = 12;                           % Total hours available

% Variables
var 0.0..int2float(num_furnaces): x1;  % Furnaces allocated to method 1 (LP relaxation)
var 0.0..int2float(num_furnaces): x2;  % Furnaces allocated to method 2 (LP relaxation)
var 0.0..int2float(m*num_furnaces + n*num_furnaces): total_fuel_cost;  % Total fuel cost

% Constraints
% --- Furnace allocation constraints ---
constraint x1 + x2 <= int2float(num_furnaces);

% --- Time availability constraints ---
constraint int2float(a) * x1 + int2float(b) * x2 <= int2float(c);

% --- Production requirement constraints ---
constraint int2float(k) * (x1 + x2) >= int2float(d);

% --- Fuel cost definition constraint ---
constraint total_fuel_cost = int2float(m) * x1 + int2float(n) * x2;

% Objective
solve minimize total_fuel_cost;