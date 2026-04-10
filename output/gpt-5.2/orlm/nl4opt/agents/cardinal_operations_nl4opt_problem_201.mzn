% Parameters
% Customer attraction rates (customers per hour)
int: customers_throw = 15;
int: customers_climb = 8;

% Prize costs (dollars per hour)
int: cost_throw = 2;
int: cost_climb = 3;

% Policy / requirement parameters
int: min_climb_games = 5;          % at least 5 climbing games
int: throw_to_climb_ratio = 2;     % throwing games >= 2 * climbing games

% Budget limit (dollars per hour)
int: max_prize_budget = 100;

% Derived safe upper bounds for decision variables (integer)
int: max_throw_games = max_prize_budget div cost_throw;  % worst-case based on budget
int: max_climb_games = max_prize_budget div cost_climb;  % worst-case based on budget


% Variables
var 0..max_throw_games: n_throw;   % number of throwing games
var 0..max_climb_games: n_climb;   % number of climbing games


% Constraints
% Prize budget constraint: total hourly prize cost cannot exceed available budget
constraint
  cost_throw * n_throw + cost_climb * n_climb <= max_prize_budget;

% Policy constraint: must have at least twice as many throwing games as climbing games
constraint
  n_throw >= throw_to_climb_ratio * n_climb;

% Minimum climbing games requirement
constraint
  n_climb >= min_climb_games;


% Objective
solve maximize customers_throw * n_throw + customers_climb * n_climb;