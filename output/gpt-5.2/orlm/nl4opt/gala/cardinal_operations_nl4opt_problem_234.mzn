% Mail staff hiring optimization (embed all data)

% Data
int: need_hours = 1000;
int: budget = 31500;

int: pt_hours = 15;
int: pt_pay   = 450;

int: ft_hours = 40;
int: ft_pay   = 1280;

% Decision variables: number of part-time and full-time staff
var 0..(need_hours div pt_hours + 1000): pt;
var 0..(need_hours div ft_hours + 1000): ft;

% Total staff
var 0..100000: staff = pt + ft;

% Constraints
constraint pt_hours * pt + ft_hours * ft >= need_hours;
constraint pt_pay * pt + ft_pay * ft <= budget;

% Objective: minimize total number of staff
solve minimize staff;

output [
  "part_time = ", show(pt), "\n",
  "full_time = ", show(ft), "\n",
  "total_staff = ", show(staff), "\n",
  "total_hours = ", show(pt_hours*pt + ft_hours*ft), "\n",
  "total_cost = ", show(pt_pay*pt + ft_pay*ft), "\n"
];