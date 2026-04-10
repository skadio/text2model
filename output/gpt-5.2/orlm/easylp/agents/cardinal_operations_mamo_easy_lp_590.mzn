% Parameters
% Unit production costs for each line
int: cost1 = 10;
int: cost2 = 15;
int: cost3 = 20;
int: cost4 = 25;

% Capacity/portfolio constraint limits
int: cap12 = 1000;            % x1 + x2 <= 1000
int: cap34 = 1500;            % 2*x3 + 3*x4 <= 1500
int: min_diff_2_13 = 300;     % x2 - (x1 + x3) >= 300
int: max_diff_3_24 = 500;     % x3 - (x2 + x4) <= 500

% The statement mentions bounds but provides no explicit values beyond constraints;
% use safe nonnegative upper bounds implied by the constraints.
int: ub1 = cap12;                % x1 <= 1000
int: ub2 = cap12;                % x2 <= 1000
int: ub3 = cap34 div 2;           % 2*x3 <= 1500 => x3 <= 750
int: ub4 = cap34 div 3;           % 3*x4 <= 1500 => x4 <= 500

% Variables
var 0..ub1: x1;  % units produced on line 1 (integer)
var 0..ub2: x2;  % units produced on line 2 (integer)
var 0..ub3: x3;  % units produced on line 3 (integer)
var 0..ub4: x4;  % units produced on line 4 (integer)

% Total production cost (objective value)
var 0..(cost1*ub1 + cost2*ub2 + cost3*ub3 + cost4*ub4): total_cost;

% Constraints
% Link total_cost to the weighted sum of production quantities
constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;

% Capacity constraint for lines 1 and 2
constraint x1 + x2 <= cap12;

% Capacity constraint for lines 3 and 4 (weighted)
constraint 2 * x3 + 3 * x4 <= cap34;

% Diversification requirement
constraint x2 - (x1 + x3) >= min_diff_2_13;

% Portfolio balance requirement
constraint x3 - (x2 + x4) <= max_diff_3_24;

% Objective
solve minimize total_cost;