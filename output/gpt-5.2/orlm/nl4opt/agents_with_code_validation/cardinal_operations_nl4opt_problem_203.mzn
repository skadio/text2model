% Parameters
int: lab_newspapers = 7;          % Newspapers delivered per labrador service
int: lab_treats = 5;              % Treats required per labrador service
int: gold_newspapers = 10;        % Newspapers delivered per golden retriever service
int: gold_treats = 6;             % Treats required per golden retriever service

int: treats_available = 1500;     % Total small bone treats available
int: min_golden = 50;             % Minimum number of golden retrievers required
int: max_lab_percent = 60;        % Maximum percentage of labradors among all dogs (percent)

% Variables
var 0..treats_available div lab_treats: num_labradors;                 % Number of labradors used
var min_golden..treats_available div gold_treats: num_goldens;         % Number of golden retrievers used

var 0..(lab_newspapers * (treats_available div lab_treats)
      + gold_newspapers * (treats_available div gold_treats)): total_newspapers; % Total newspapers delivered

% Constraints
% Treat budget: total treats used by all dogs cannot exceed available treats
constraint
  lab_treats * num_labradors + gold_treats * num_goldens <= treats_available;

% Labrador proportion limit: at most max_lab_percent% of all dogs can be labradors
% Avoid division by cross-multiplying: 100*L <= p*(L+G)
constraint
  100 * num_labradors <= max_lab_percent * (num_labradors + num_goldens);

% Define total newspapers delivered based on chosen numbers of dogs
constraint
  total_newspapers = lab_newspapers * num_labradors + gold_newspapers * num_goldens;

% Objective
solve maximize total_newspapers;