% Resource allocation for an educational institution
% All data embedded; integer decision variables.

int: c_teacher = 5;
int: c_maint   = 2;
int: c_text    = 3;
int: c_online  = 1;

int: min_teacher = 1500;
int: min_maint   = 500;
int: min_text    = 200;
int: min_online  = 100;

int: min_teacher_plus_maint = 3000;
int: max_text_minus_online  = 500;
int: max_total_allocation   = 5000;
int: min_teacher_minus_maint = 1000;

var int: teacher >= min_teacher;
var int: maint   >= min_maint;
var int: text    >= min_text;
var int: online  >= min_online;

constraint teacher + maint >= min_teacher_plus_maint;
constraint text - online <= max_text_minus_online;
constraint online - text <= max_text_minus_online; % absolute difference
constraint teacher + maint + text + online <= max_total_allocation;
constraint teacher - maint >= min_teacher_minus_maint;

var int: total_cost = c_teacher*teacher + c_maint*maint + c_text*text + c_online*online;

solve minimize total_cost;

output [
  "teacher=", show(teacher), "\n",
  "maint=", show(maint), "\n",
  "text=", show(text), "\n",
  "online=", show(online), "\n",
  "total_allocation=", show(teacher+maint+text+online), "\n",
  "min_total_cost=", show(total_cost), "\n"
];