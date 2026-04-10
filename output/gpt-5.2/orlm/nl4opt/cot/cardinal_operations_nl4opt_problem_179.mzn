% Parameters (with values embedded)
int: total_investment = 600000;
int: max_apartments = 200000;
float: apt_return = 0.10;
float: town_return = 0.15;

% Variables
var 0..max_apartments: A;                 % dollars invested in apartments
var 0..total_investment: T;               % dollars invested in townhouses
var float: profit;

% Constraints
constraint A + T = total_investment;
constraint A <= max_apartments;
constraint 2 * A >= T;                    % A >= 0.5 * T

% Objective
constraint profit = apt_return * int2float(A) + town_return * int2float(T);
solve maximize profit;