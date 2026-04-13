% Soda delivery: minimize pollution subject to bottle demand and van limits

int: capacity_old = 100;
int: capacity_new = 80;

int: pollution_old = 50;
int: pollution_new = 30;

int: demand = 5000;
int: max_new_vans = 30;

% Decision variables
var 0..demand div capacity_old + 100: old_vans;
var 0..max_new_vans: new_vans;

% Constraints
constraint capacity_old * old_vans + capacity_new * new_vans >= demand;
constraint new_vans <= max_new_vans;

% Objective: minimize total pollution
var int: total_pollution = pollution_old * old_vans + pollution_new * new_vans;
solve minimize total_pollution;

output [
  "old_vans=", show(old_vans), "\n",
  "new_vans=", show(new_vans), "\n",
  "total_bottles=", show(capacity_old * old_vans + capacity_new * new_vans), "\n",
  "total_pollution=", show(total_pollution), "\n"
];