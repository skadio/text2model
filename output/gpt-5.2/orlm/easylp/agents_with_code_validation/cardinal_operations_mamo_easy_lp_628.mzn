% Parameters
int: salary_x1 = 5000;   % monthly salary per employee in department x1
int: salary_x2 = 4000;   % monthly salary per employee in department x2
int: salary_x3 = 6000;   % monthly salary per employee in department x3
int: salary_x4 = 7000;   % monthly salary per employee in department x4

int: max_x1 = 50;        % upper bound on employees in x1
int: max_x2 = 60;        % upper bound on employees in x2
int: max_x3 = 40;        % upper bound on employees in x3
int: max_x4 = 40;        % upper bound on employees in x4

int: max_x1_x2 = 100;    % space limit: x1 + x2 <= 100
int: max_x3_x4 = 80;     % resource limit: x3 + x4 <= 80

int: diff_x4_x2 = 30;    % balance limit: |x4 - x2| <= 30

% Variables
var 0..max_x1: x1;       % number of employees in department x1
var 0..max_x2: x2;       % number of employees in department x2
var 0..max_x3: x3;       % number of employees in department x3
var 0..max_x4: x4;       % number of employees in department x4

% Total monthly salary expense (bounded by maximum possible total cost)
var 0..(salary_x1*max_x1 + salary_x2*max_x2 + salary_x3*max_x3 + salary_x4*max_x4): total_cost;

% Constraints
% Define total cost
constraint total_cost = salary_x1*x1 + salary_x2*x2 + salary_x3*x3 + salary_x4*x4;

% Capacity constraints across paired departments
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% Supervision constraint: x1 must be at least 20 more than half of x3
% Integer-safe form: x1 >= x3/2 + 20  <=>  2*x1 >= x3 + 40
constraint 2 * x1 >= x3 + 40;

% Balance constraint between departments x4 and x2
constraint abs(x4 - x2) <= diff_x4_x2;

% Objective
solve minimize total_cost;