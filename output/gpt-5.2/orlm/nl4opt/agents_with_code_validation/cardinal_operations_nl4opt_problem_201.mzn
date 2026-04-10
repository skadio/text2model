% Parameters
% Customers attracted per hour by each game type
int: customers_throwing = 15;
int: customers_climbing = 8;

% Prize cost per hour by each game type (in $)
int: cost_throwing = 2;
int: cost_climbing = 3;

% Policy / requirement parameters
int: min_climbing = 5;          % at least this many climbing games
int: throwing_to_climbing = 2;  % throwing games must be at least this multiple of climbing
int: max_prize_budget = 100;    % maximum $ spent on prizes per hour

% Variables
% Number of games of each type (non-negative integers), bounded by prize budget
var 0..max_prize_budget div cost_throwing: n_throwing; % throwing games
var 0..max_prize_budget div cost_climbing: n_climbing; % climbing games

% Total customers attracted per hour (bounded using max possible counts under budget)
var 0..(customers_throwing * (max_prize_budget div cost_throwing)
      + customers_climbing * (max_prize_budget div cost_climbing)): total_customers;

% Constraints
% Budget constraint: total prize cost per hour cannot exceed the maximum budget
constraint
  cost_throwing * n_throwing + cost_climbing * n_climbing <= max_prize_budget;

% Policy constraint: must have at least the minimum number of climbing games
constraint
  n_climbing >= min_climbing;

% Policy constraint: throwing games must be at least a multiple of climbing games
constraint
  n_throwing >= throwing_to_climbing * n_climbing;

% Definition constraint: total customers attracted per hour
constraint
  total_customers = customers_throwing * n_throwing + customers_climbing * n_climbing;

% Objective
solve maximize total_customers;