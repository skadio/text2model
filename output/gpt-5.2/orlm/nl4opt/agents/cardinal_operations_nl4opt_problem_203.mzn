% Parameters
int: labrador_capacity = 7;          % newspapers delivered per labrador
int: labrador_treats = 5;            % treats required per labrador
int: golden_capacity = 10;           % newspapers delivered per golden retriever
int: golden_treats = 6;              % treats required per golden retriever

int: total_treats_available = 1500;  % total small bone treats available
int: min_golden = 50;                % minimum number of golden retrievers
int: max_labrador_percent = 60;      % maximum percent of dogs that can be labradors

% Variables
var 0..total_treats_available: num_labradors;                 % number of labradors used
var min_golden..total_treats_available: num_goldens;          % number of golden retrievers used

var 0..(labrador_capacity * total_treats_available div labrador_treats
        + golden_capacity * total_treats_available div golden_treats): total_newspapers;
  % total newspapers delivered (objective expression)

% Constraints

% Treat budget constraint: total treats used by both types cannot exceed available treats
constraint
  labrador_treats * num_labradors + golden_treats * num_goldens <= total_treats_available;

% Minimum number of golden retrievers (redundant with var domain, kept for clarity)
constraint
  num_goldens >= min_golden;

% Labrador proportion constraint: at most max_labrador_percent% of all dogs are labradors
% Avoid division by cross-multiplying to keep everything integer-safe:
% num_labradors / (num_labradors + num_goldens) <= max_labrador_percent / 100
constraint
  100 * num_labradors <= max_labrador_percent * (num_labradors + num_goldens);

% Define total newspapers delivered based on chosen numbers of dogs
constraint
  total_newspapers = labrador_capacity * num_labradors + golden_capacity * num_goldens;

% Objective
solve maximize total_newspapers;