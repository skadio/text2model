% Parameters
int: total_space = 100;          % sq. feet available
int: max_budget = 5000;          % dollars
int: max_labor = 2000;           % hours

int: phone_labor = 2;            % hours per sq. foot
int: laptop_labor = 3;           % hours per sq. foot

int: phone_cost = 12;            % dollars per sq. foot
int: laptop_cost = 15;           % dollars per sq. foot

int: phone_revenue = 50;         % dollars per sq. foot
int: laptop_revenue = 70;        % dollars per sq. foot

% Variables
var 0..total_space: phone_space;
var 0..total_space: laptop_space;

var 0..max_budget: total_cost;
var 0..max_labor: total_labor;
var 0..(phone_revenue * total_space + laptop_revenue * total_space): total_revenue;

% Constraints
constraint phone_space + laptop_space <= total_space;

constraint total_cost = phone_cost * phone_space + laptop_cost * laptop_space;
constraint total_cost <= max_budget;

constraint total_labor = phone_labor * phone_space + laptop_labor * laptop_space;
constraint total_labor <= max_labor;

constraint total_revenue = phone_revenue * phone_space + laptop_revenue * laptop_space;

% Objective
solve maximize total_revenue;