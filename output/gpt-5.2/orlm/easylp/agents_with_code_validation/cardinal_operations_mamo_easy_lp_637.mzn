% Parameters
% Cost coefficients (funding units per unit allocation)
int: cost_teacher = 5;
int: cost_maintenance = 2;
int: cost_textbooks = 3;
int: cost_online = 1;

% Budget / policy constraints
int: min_teacher_plus_maintenance = 3000;
int: max_textbooks_minus_online_abs = 500;
int: max_total_allocation = 5000;
int: min_teacher_minus_maintenance = 1000;

% Minimum allocation requirements (all allocations are integers)
int: min_teacher = 1500;
int: min_maintenance = 500;
int: min_textbooks = 200;
int: min_online = 100;


% Variables
var int: teacher_salary;          % allocation for teacher salaries
var int: classroom_maintenance;   % allocation for classroom maintenance
var int: textbook_costs;          % allocation for textbooks
var int: online_tools;            % allocation for online tools

var int: total_cost;              % total funding cost to minimize


% Constraints
% --- Minimum allocation requirements and finite upper bounds (from total allocation cap) ---
constraint teacher_salary >= min_teacher /\ teacher_salary <= max_total_allocation;
constraint classroom_maintenance >= min_maintenance /\ classroom_maintenance <= max_total_allocation;
constraint textbook_costs >= min_textbooks /\ textbook_costs <= max_total_allocation;
constraint online_tools >= min_online /\ online_tools <= max_total_allocation;

% --- Policy / budget constraints on allocations ---
constraint teacher_salary + classroom_maintenance >= min_teacher_plus_maintenance;
constraint abs(textbook_costs - online_tools) <= max_textbooks_minus_online_abs;
constraint teacher_salary + classroom_maintenance + textbook_costs + online_tools <= max_total_allocation;
constraint teacher_salary - classroom_maintenance >= min_teacher_minus_maintenance;

% --- Total cost definition (linking variable to linear expression) ---
constraint total_cost =
    cost_teacher * teacher_salary
  + cost_maintenance * classroom_maintenance
  + cost_textbooks * textbook_costs
  + cost_online * online_tools;


% Objective
solve minimize total_cost;