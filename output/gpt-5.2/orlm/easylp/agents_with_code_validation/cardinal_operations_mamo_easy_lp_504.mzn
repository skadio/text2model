% Parameters
%----------------------------
% Budget limits (all integer budgets)
%----------------------------
int: max_X1 = 5000;                  % Maximum budget for channel X1
int: max_X2 = 4000;                  % Maximum budget for channel X2
int: max_X3 = 3000;                  % Maximum budget for channel X3
int: max_total_budget = 10000;       % Maximum total budget across all channels

%----------------------------
% Campaign requirements
%----------------------------
int: min_effectiveness = 2000;       % Minimum required effectiveness score
int: max_balance_diff = 1500;        % Maximum allowed balance difference

%----------------------------
% Unit costs
%----------------------------
int: cost_X1 = 5000;                 % Cost per unit for channel X1
int: cost_X2 = 3000;                 % Cost per unit for channel X2
int: cost_X3 = 7000;                 % Cost per unit for channel X3


% Variables
%----------------------------
% Decision variables: integer budgets per channel
%----------------------------
var 0..max_X1: X1;
var 0..max_X2: X2;
var 0..max_X3: X3;

% Total cost (bounded above by worst-case spending at variable maxima)
var 0..(cost_X1*max_X1 + cost_X2*max_X2 + cost_X3*max_X3): total_cost;


% Constraints
%----------------------------
% Total budget limit
%----------------------------
constraint
  X1 + X2 + X3 <= max_total_budget;

%----------------------------
% Minimum effectiveness requirement
% Effectiveness: 2*X1 - 3*X2 + 4.5*X3 >= 2000
% Multiply by 2 to keep integer arithmetic:
% 4*X1 - 6*X2 + 9*X3 >= 2*min_effectiveness
%----------------------------
constraint
  4 * X1 - 6 * X2 + 9 * X3 >= 2 * min_effectiveness;

%----------------------------
% Balanced exposure constraint
% |0.5*X2 - (X1 + 0.75*X3)| <= 1500
% Multiply by 4 to keep integer arithmetic:
% |2*X2 - (4*X1 + 3*X3)| <= 4*max_balance_diff
%----------------------------
constraint
  abs(2 * X2 - (4 * X1 + 3 * X3)) <= 4 * max_balance_diff;

%----------------------------
% Total cost definition
%----------------------------
constraint
  total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3;


% Objective
solve minimize total_cost;