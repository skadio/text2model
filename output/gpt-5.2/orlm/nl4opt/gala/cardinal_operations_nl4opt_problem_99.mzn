include "globals.mzn";

/* Data (embedded from problem statement) */
int: employees_available = 150;

int: emp_small = 3;
int: emp_large = 5;

int: mow_small = 50;  % sq ft per small team
int: mow_large = 80;  % sq ft per large team

int: min_small = 10;
int: min_large = 6;

/* Decision variables */
var min_small..employees_available div emp_small: small_teams;
var min_large..employees_available div emp_large: large_teams;

/* Constraints */
constraint emp_small * small_teams + emp_large * large_teams <= employees_available;
constraint small_teams >= 3 * large_teams;

/* Objective */
var int: total_mowed = mow_small * small_teams + mow_large * large_teams;

solve maximize total_mowed;

/* Output */
output [
  "small_teams = ", show(small_teams), "\n",
  "large_teams = ", show(large_teams), "\n",
  "employees_used = ", show(emp_small * small_teams + emp_large * large_teams), " / ", show(employees_available), "\n",
  "total_mowed_sqft = ", show(total_mowed), "\n"
];