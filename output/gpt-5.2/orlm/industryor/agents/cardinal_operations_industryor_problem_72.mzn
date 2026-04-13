% Parameters
set of int: CHILDREN = 1..5;              % Index set for children
int: Alice = 1;
int: Bob = 2;
int: Charlie = 3;
int: Diana = 4;
int: Ella = 5;

array[CHILDREN] of int: cost =            % Cost of taking each child
  [1000, 900, 600, 500, 700];

int: max_children = 3;                    % Can take up to 3 children
int: min_children = 2;                    % Must take at least 2 children

% Variables
array[CHILDREN] of var 0..1: take;        % take[i]=1 if child i is taken, else 0
var 0..sum(cost): total_cost;             % Total cost of selected children

% Constraints
% Link total_cost to the selected children
constraint total_cost = sum(i in CHILDREN)(cost[i] * take[i]);

% Capacity constraint: can take at most max_children children
constraint sum(i in CHILDREN)(take[i]) <= max_children;

% Minimum selection constraint: must take at least min_children children
constraint sum(i in CHILDREN)(take[i]) >= min_children;

% Mandatory child: Bob is definitely taken
constraint take[Bob] = 1;

% Incompatibility constraints (cannot take both)
constraint take[Alice] + take[Diana] <= 1;      % If Alice is taken, Diana is not
constraint take[Bob] + take[Charlie] <= 1;      % If Bob is taken, Charlie is not

% Implication constraints (if one is taken, another must also be taken)
constraint take[Charlie] <= take[Diana];        % If Charlie is taken, Diana must be taken
constraint take[Diana] <= take[Ella];           % If Diana is taken, Ella must be taken

% Objective
solve minimize total_cost;