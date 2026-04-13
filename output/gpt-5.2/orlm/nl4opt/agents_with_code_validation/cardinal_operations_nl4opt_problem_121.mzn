% Parameters
int: budget = 500;                 % maximum monthly spend ($)
float: cost_carrot = 0.30;         % cost per carrot ($) [informational; cents used in constraints]
float: cost_cucumber = 0.50;       % cost per cucumber ($) [informational; cents used in constraints]
float: profit_carrot = 0.75;       % profit per carrot ($) [informational; cents used in objective]
float: profit_cucumber = 0.80;     % profit per cucumber ($) [informational; cents used in objective]

int: min_carrots = 300;            % minimum carrots sold per month
int: max_carrots = 500;            % maximum carrots sold per month

% cucumber sales constraint: cucumbers <= (1/3) * carrots
int: cucumber_ratio_num = 1;       % numerator
int: cucumber_ratio_den = 3;       % denominator


% Variables
var min_carrots..max_carrots: carrots_sold;  % number of carrots sold
var 0..(max_carrots div cucumber_ratio_den): cucumbers_sold; % number of cucumbers sold (bounded)

% Objective variable (scaled to cents to remain integer)
var int: profit_cents;             % total profit in cents


% Constraints

%-----------------------------
% Budget (spending) constraint
%-----------------------------
% Convert dollars to cents to keep the constraint integer:
% 0.30 = 30 cents, 0.50 = 50 cents, budget 500 = 50000 cents
constraint
  30 * carrots_sold + 50 * cucumbers_sold <= 100 * budget;

%-----------------------------------------
% Cucumber-to-carrot sales ratio constraint
%-----------------------------------------
% cucumbers_sold <= (1/3) * carrots_sold  ->  3*cucumbers_sold <= 1*carrots_sold
constraint
  cucumber_ratio_den * cucumbers_sold <= cucumber_ratio_num * carrots_sold;

%-------------------------
% Profit definition (cents)
%-------------------------
% 0.75 = 75 cents, 0.80 = 80 cents
constraint
  profit_cents = 75 * carrots_sold + 80 * cucumbers_sold;


% Objective
solve maximize profit_cents;