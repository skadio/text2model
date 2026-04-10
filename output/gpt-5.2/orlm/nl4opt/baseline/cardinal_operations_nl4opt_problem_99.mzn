int: employees_available = 150;

int: emp_small = 3;
int: emp_large = 5;

int: mow_small = 50;
int: mow_large = 80;

int: min_large = 6;
int: min_small = 10;

var int: small_teams;
var int: large_teams;

constraint small_teams >= min_small;
constraint large_teams >= min_large;

constraint emp_small * small_teams + emp_large * large_teams <= employees_available;

constraint small_teams >= 3 * large_teams;

solve maximize mow_small * small_teams + mow_large * large_teams;

output [
  "small_teams = ", show(small_teams), "\n",
  "large_teams = ", show(large_teams), "\n",
  "total_employees_used = ", show(emp_small * small_teams + emp_large * large_teams), "\n",
  "total_sqft_mowed = ", show(mow_small * small_teams + mow_large * large_teams), "\n"
];