% Parameters
int: w_teacher = 5;
int: w_maint = 2;
int: w_text = 3;
int: w_online = 1;

int: min_teacher = 1500;
int: min_maint = 500;
int: min_text = 200;
int: min_online = 100;

int: min_teacher_plus_maint = 3000;
int: max_text_minus_online = 500;
int: max_total_alloc = 5000;
int: min_teacher_minus_maint = 1000;

% Variables
var min_teacher..max_total_alloc: teacher;
var min_maint..max_total_alloc: maint;
var min_text..max_total_alloc: text;
var min_online..max_total_alloc: online;

var 0..(w_teacher*max_total_alloc + w_maint*max_total_alloc + w_text*max_total_alloc + w_online*max_total_alloc): total_cost;

% Constraints
constraint teacher + maint >= min_teacher_plus_maint;
constraint text - online <= max_text_minus_online;
constraint online - text <= max_text_minus_online;
constraint teacher + maint + text + online <= max_total_alloc;
constraint teacher - maint >= min_teacher_minus_maint;

constraint total_cost = w_teacher*teacher + w_maint*maint + w_text*text + w_online*online;

% Objective
solve minimize total_cost;