% Parameters
int: teacher_cost = 5;
int: classroom_cost = 2;
int: textbook_cost = 3;
int: online_cost = 1;

int: min_teacher = 1500;
int: min_classroom = 500;
int: min_textbook = 200;
int: min_online = 100;

int: min_teacher_plus_classroom = 3000;
int: max_textbook_minus_online = 500;
int: max_total_allocation = 5000;
int: min_teacher_minus_classroom = 1000;

% Variables
var min_teacher..max_total_allocation: teacher;
var min_classroom..max_total_allocation: classroom;
var min_textbook..max_total_allocation: textbook;
var min_online..max_total_allocation: online;

var 0..(teacher_cost + classroom_cost + textbook_cost + online_cost) * max_total_allocation: total_cost;

% Constraints
constraint teacher + classroom >= min_teacher_plus_classroom;
constraint textbook - online <= max_textbook_minus_online;
constraint teacher - classroom >= min_teacher_minus_classroom;
constraint teacher + classroom + textbook + online <= max_total_allocation;

constraint total_cost = teacher_cost * teacher
                      + classroom_cost * classroom
                      + textbook_cost * textbook
                      + online_cost * online;

% Objective
solve minimize total_cost;