% Annotation outsourcing cost minimization
% All data embedded as requested.

include "globals.mzn";

% Parameters (given)
int: min_images = 10000;

int: rate_spec = 60;     % images/hour
int: rate_common = 40;   % images/hour

int: cost_spec = 100;    % $/hour
int: cost_common = 72;   % $/hour

% Decision variables: hours purchased from each company (nonnegative integers)
var 0..100000: h_spec;
var 0..100000: h_common;

% Produced images
var 0..intmax: img_spec = rate_spec * h_spec;
var 0..intmax: img_common = rate_common * h_common;
var 0..intmax: img_total = img_spec + img_common;

% Total cost
var 0..intmax: total_cost = cost_spec * h_spec + cost_common * h_common;

% Constraints
constraint img_total >= min_images;

% At least one third of the work (images) must be done by specialized:
% img_spec >= (1/3) * img_total  <=>  3*img_spec >= img_total
constraint 3 * img_spec >= img_total;

solve minimize total_cost;

output [
  "Hours (specialized) = ", show(h_spec), "\n",
  "Hours (common)      = ", show(h_common), "\n",
  "Images (specialized)= ", show(img_spec), "\n",
  "Images (common)     = ", show(img_common), "\n",
  "Images (total)      = ", show(img_total), "\n",
  "Total cost ($)      = ", show(total_cost), "\n"
];