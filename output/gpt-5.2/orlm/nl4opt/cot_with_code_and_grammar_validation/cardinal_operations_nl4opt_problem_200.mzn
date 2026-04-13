% Parameters
int: total_space = 100;
int: max_budget = 5000;
int: max_labor = 2000;

int: labor_phone = 2;
int: labor_laptop = 3;

int: cost_phone = 12;
int: cost_laptop = 15;

int: revenue_phone = 50;
int: revenue_laptop = 70;

% Variables
var 0..total_space: space_phone;
var 0..total_space: space_laptop;

var 0..max_budget: total_cost;
var 0..max_labor: total_labor;
var 0..(revenue_phone * total_space + revenue_laptop * total_space): total_revenue;

% Constraints
constraint space_phone + space_laptop <= total_space;

constraint total_cost = cost_phone * space_phone + cost_laptop * space_laptop;
constraint total_cost <= max_budget;

constraint total_labor = labor_phone * space_phone + labor_laptop * space_laptop;
constraint total_labor <= max_labor;

constraint total_revenue = revenue_phone * space_phone + revenue_laptop * space_laptop;

% Objective
solve maximize total_revenue;