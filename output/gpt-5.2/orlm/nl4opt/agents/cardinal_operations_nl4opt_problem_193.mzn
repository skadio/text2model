% Parameters
int: small_capacity = 20;          % Students carried by one small bus
int: large_capacity = 50;          % Students carried by one large bus
int: min_students = 500;           % Minimum number of students to transport
float: max_large_fraction = 0.20;  % Maximum fraction of buses that can be large

% Variables
% Upper bounds based on using only that bus type to meet the minimum students
var 0..ceil(int2float(min_students) / int2float(small_capacity)): num_small;  % Number of small buses
var 0..ceil(int2float(min_students) / int2float(large_capacity)): num_large;  % Number of large buses

% Constraints
% Meet minimum student transportation requirement
constraint
  small_capacity * num_small + large_capacity * num_large >= min_students;

% Limit fraction of large buses to at most max_large_fraction of total buses
% Avoid division by rewriting: num_large <= 0.2 * (num_small + num_large)
constraint
  int2float(num_large) <= max_large_fraction * int2float(num_small + num_large);

% Objective
solve minimize (num_small + num_large);