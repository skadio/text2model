% Parameters
int: cost_plush = 3;                 % cost to buy one plush toy ($)
int: cost_doll  = 2;                 % cost to buy one doll ($)
int: budget_max = 700;               % maximum inventory budget ($)

int: profit_plush = 4;               % profit per plush toy sold ($)
int: profit_doll  = 2;               % profit per doll sold ($)

int: plush_sold_min = 90;            % minimum plush toys sold per month
int: plush_sold_max = 190;           % maximum plush toys sold per month

int: doll_to_plush_ratio_max = 2;    % dolls sold <= 2 * plush sold


% Variables
var 0..(budget_max div cost_plush): plush;   % number of plush toys bought/sold
var 0..(budget_max div cost_doll):  doll;    % number of dolls bought/sold
var int: total_profit;                       % total monthly profit ($)


% Constraints
% --- Budget constraint: total inventory cost must not exceed available budget ---
constraint cost_plush * plush + cost_doll * doll <= budget_max;

% --- Demand bounds for plush toys: estimated monthly sales range ---
constraint plush >= plush_sold_min;
constraint plush <= plush_sold_max;

% --- Sales relationship: dolls sold is at most a multiple of plush sold ---
constraint doll <= doll_to_plush_ratio_max * plush;

% --- Profit definition: link total_profit to decision variables ---
constraint total_profit = profit_plush * plush + profit_doll * doll;


% Objective
solve maximize total_profit;

% (Optional) Output for readability
output [
  "plush = ", show(plush), "\n",
  "doll = ", show(doll), "\n",
  "total_profit = ", show(total_profit), "\n"
];