% Parameters (with values embedded)
int: hours_required = 1000;
int: budget = 40000;

int: staff_hours = 6;
int: staff_pay = 300;

int: sub_hours = 3;
int: sub_pay = 100;

% Variables
var 0..(hours_required div staff_hours): staff_teachers;
var 0..(hours_required div sub_hours): substitute_teachers;

% Constraints
constraint staff_hours * staff_teachers + sub_hours * substitute_teachers >= hours_required;
constraint staff_pay * staff_teachers + sub_pay * substitute_teachers <= budget;

% Objective
solve minimize staff_teachers + substitute_teachers;