% Parameters
int: cost_plush = 3;              % purchase cost per plush toy ($)
int: cost_doll  = 2;              % purchase cost per doll ($)
int: budget_max = 700;            % maximum inventory budget ($)

int: profit_plush = 4;            % profit per plush toy sold ($)
int: profit_doll  = 2;            % profit per doll sold ($)

int: plush_sold_min = 90;         % minimum plush toys sold per month
int: plush_sold_max = 190;        % maximum plush toys sold per month
int: dolls_per_plush_max = 2;     % dolls sold <= 2 * plush sold

% Variables
var 0..(budget_max div cost_plush): plush_bought;   % number of plush toys bought
var 0..(budget_max div cost_doll):  dolls_bought;   % number of dolls bought

var plush_sold_min..plush_sold_max: plush_sold;     % number of plush toys sold
var 0..(2 * plush_sold_max):        dolls_sold;     % number of dolls sold

% Constraints
% Budget constraint: total purchasing cost must not exceed available budget
constraint
  cost_plush * plush_bought + cost_doll * dolls_bought <= budget_max;

% Inventory feasibility: cannot sell more items than are bought
constraint plush_sold <= plush_bought;
constraint dolls_sold  <= dolls_bought;

% Demand/market relationship: dolls sold is at most twice plush sold
constraint dolls_sold <= dolls_per_plush_max * plush_sold;

% Objective
solve maximize profit_plush * plush_sold + profit_doll * dolls_sold;