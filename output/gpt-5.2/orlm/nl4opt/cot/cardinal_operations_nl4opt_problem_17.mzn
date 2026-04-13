% Parameters (with values embedded)
int: time_cleansing = 4;          % minutes per unit of cleansing chemical
int: time_odor = 6;              % minutes per unit of odor-removing chemical
int: min_cleansing = 100;        % at least this many units of cleansing
int: min_total = 300;            % at least this many total units
int: max_total = 1000000;        % safe upper bound for search

% Variables
var 0..max_total: x;             % units of cleansing chemical
var 0..max_total: y;             % units of odor-removing chemical

% Constraints
constraint x >= min_cleansing;
constraint x + y >= min_total;
constraint x <= 2 * y;

% Objective
solve minimize time_cleansing * x + time_odor * y;