% Parameters
% Substance usage per container (grams)
int: a_max = 46;        % substance A in Oil Max
int: b_max = 43;        % substance B in Oil Max
int: c_max = 56;        % substance C in Oil Max

int: a_pro = 13;        % substance A in Oil Max Pro
int: b_pro = 4;         % substance B in Oil Max Pro
int: c_pro = 45;        % substance C in Oil Max Pro

% Available amounts of each substance (grams)
int: A_available = 1345;
int: B_available = 346;
int: C_available = 1643;

% Profit per container ($)
int: profit_max = 10;
int: profit_pro = 15;

% Variables
% Upper bounds derived from substance A alone (safe but not necessarily tight)
var 0..(A_available div a_max): x_max;   % number of Oil Max containers
var 0..(A_available div a_pro): x_pro;   % number of Oil Max Pro containers

var int: total_profit;                  % total profit to maximize

% Constraints
% Link total profit to decision variables
constraint total_profit = profit_max * x_max + profit_pro * x_pro;

% Resource availability constraints
constraint a_max * x_max + a_pro * x_pro <= A_available;
constraint b_max * x_max + b_pro * x_pro <= B_available;
constraint c_max * x_max + c_pro * x_pro <= C_available;

% Objective
solve maximize total_profit;