% Parameters
int: min_math = 40;            % Minimum number of math workbooks to produce
int: min_english = 60;         % Minimum number of English workbooks to produce
int: max_math = 140;           % Maximum number of math workbooks to produce
int: max_english = 170;        % Maximum number of English workbooks to produce
int: min_total = 200;          % Minimum total number of workbooks (math + English)
int: profit_math = 15;         % Profit per math workbook
int: profit_english = 17;      % Profit per English workbook

% Variables
var min_math..max_math: math_workbooks;            % Number of math workbooks to produce
var min_english..max_english: english_workbooks;   % Number of English workbooks to produce
var 0..(profit_math*max_math + profit_english*max_english): total_profit; % Total profit (bounded)

% Constraints
% Contract constraint: ship at least the minimum total number of workbooks
constraint
  math_workbooks + english_workbooks >= min_total;

% Profit definition: link total_profit to decision variables
constraint
  total_profit = profit_math * math_workbooks + profit_english * english_workbooks;

% Objective
solve maximize total_profit;