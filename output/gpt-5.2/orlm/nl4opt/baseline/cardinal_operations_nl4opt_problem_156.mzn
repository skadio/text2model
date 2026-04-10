% Outsourcing image annotations: minimize cost
% Data embedded as requested.

% Parameters
int: total_images = 10000;
int: rate_special = 60;   % images per hour
int: rate_common  = 40;   % images per hour
int: cost_special = 100;  % $ per hour
int: cost_common  = 72;   % $ per hour

% Decision variables: number of hours assigned to each company
var 0..1000000: h_special;
var 0..1000000: h_common;

% Derived totals
var 0..100000000: imgs_special = rate_special * h_special;
var 0..100000000: imgs_common  = rate_common  * h_common;
var 0..100000000: imgs_total   = imgs_special + imgs_common;

% Constraints
constraint imgs_total >= total_images;

% At least one third of total work (images) must be done by specialized company:
% imgs_special >= (1/3) * imgs_total  <=>  3*imgs_special >= imgs_total
constraint 3 * imgs_special >= imgs_total;

% Objective: minimize total cost
var 0..100000000: total_cost = cost_special * h_special + cost_common * h_common;
solve minimize total_cost;

output [
  "Specialized hours: ", show(h_special), "\n",
  "Common hours: ", show(h_common), "\n",
  "Specialized images: ", show(imgs_special), "\n",
  "Common images: ", show(imgs_common), "\n",
  "Total images: ", show(imgs_total), "\n",
  "Total cost ($): ", show(total_cost), "\n"
];