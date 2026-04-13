% Parameters
int: profitA = 3;                % Profit per unit of product A (£)
int: profitB = 5;                % Profit per unit of product B (£)

int: timeA_min = 12;             % Assembly time per unit of A (minutes)
int: timeB_min = 25;             % Assembly time per unit of B (minutes)

int: available_hours = 30;       % Effective machine working time per week (hours)
int: available_time_min = available_hours * 60;  % Available time in minutes

int: ratioA = 5;                 % Ratio constraint: for every 5 units of A ...
int: ratioB = 2;                 % ... at least 2 units of B must be produced


% Variables
var 0..available_time_min div timeA_min: unitsA;  % Units of product A produced
var 0..available_time_min div timeB_min: unitsB;  % Units of product B produced

% Total weekly profit (£) upper bound based on max possible units individually
var 0..(profitA * (available_time_min div timeA_min) +
        profitB * (available_time_min div timeB_min)): totalProfit;


% Constraints
% --- Machine time capacity ---
% Total assembly time used by both products cannot exceed available weekly machine time.
constraint
  timeA_min * unitsA + timeB_min * unitsB <= available_time_min;

% --- Technical production ratio constraint ---
% For every ratioA units of A produced, at least ratioB units of B must be produced:
% unitsB >= (ratioB/ratioA) * unitsA  ->  ratioA*unitsB >= ratioB*unitsA
constraint
  ratioA * unitsB >= ratioB * unitsA;

% --- Profit definition ---
% Define totalProfit from produced quantities and unit profits.
constraint
  totalProfit = profitA * unitsA + profitB * unitsB;


% Objective
solve maximize totalProfit;