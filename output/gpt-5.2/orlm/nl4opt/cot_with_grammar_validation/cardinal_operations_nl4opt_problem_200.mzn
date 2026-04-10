% Parameters
int: total_space = 100;
int: max_budget = 5000;
int: max_labor = 2000;

int: phone_labor_per_sqft = 2;
int: laptop_labor_per_sqft = 3;

int: phone_cost_per_sqft = 12;
int: laptop_cost_per_sqft = 15;

int: phone_revenue_per_sqft = 50;
int: laptop_revenue_per_sqft = 70;

% Variables
var 0..total_space: phone_space;
var 0..total_space: laptop_space;

var 0..max_budget: total_cost;
var 0..max_labor: total_labor;

var 0..(phone_revenue_per_sqft * total_space + laptop_revenue_per_sqft * total_space): total_revenue;

% Constraints
constraint phone_space + laptop_space <= total_space;

constraint total_cost = phone_cost_per_sqft * phone_space + laptop_cost_per_sqft * laptop_space;
constraint total_cost <= max_budget;

constraint total_labor = phone_labor_per_sqft * phone_space + laptop_labor_per_sqft * laptop_space;
constraint total_labor <= max_labor;

constraint total_revenue = phone_revenue_per_sqft * phone_space + laptop_revenue_per_sqft * laptop_space;

% Objective
solve maximize total_revenue;