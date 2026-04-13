% Parameters
% Cost (funding units) per unit allocation
int: cost_teacher_salary = 5;
int: cost_classroom_maintenance = 2;
int: cost_textbooks = 3;
int: cost_online_tools = 1;

% Constraint thresholds
int: min_teacher_plus_maintenance = 3000;
int: max_textbooks_minus_online = 500;
int: max_total_allocation = 5000;
int: min_teacher_minus_maintenance = 1000;

% Minimum allocation requirements (lower bounds)
int: min_teacher_salary = 1500;
int: min_classroom_maintenance = 500;
int: min_textbooks = 200;
int: min_online_tools = 100;


% Variables
% Allocations (whole numbers)
var int: teacher_salary;
var int: classroom_maintenance;
var int: textbooks;
var int: online_tools;

% Total funding cost (objective value)
var int: total_cost;


% Constraints
% Link total_cost to the weighted sum of allocations (funding cost accounting)
constraint total_cost =
  cost_teacher_salary * teacher_salary +
  cost_classroom_maintenance * classroom_maintenance +
  cost_textbooks * textbooks +
  cost_online_tools * online_tools;

% Minimum allocation requirements (lower bounds)
constraint teacher_salary >= min_teacher_salary;
constraint classroom_maintenance >= min_classroom_maintenance;
constraint textbooks >= min_textbooks;
constraint online_tools >= min_online_tools;

% Upper bounds implied by overall cap (simple pruning bounds)
constraint teacher_salary <= max_total_allocation;
constraint classroom_maintenance <= max_total_allocation;
constraint textbooks <= max_total_allocation;
constraint online_tools <= max_total_allocation;

% Budget/resource feasibility constraints
constraint teacher_salary + classroom_maintenance >= min_teacher_plus_maintenance;
constraint teacher_salary + classroom_maintenance + textbooks + online_tools <= max_total_allocation;

% Relative allocation constraints
constraint teacher_salary - classroom_maintenance >= min_teacher_minus_maintenance;

% Textbook vs online tools difference limit (as specified: textbooks - online_tools <= 500)
constraint textbooks - online_tools <= max_textbooks_minus_online;


% Objective
solve minimize total_cost;