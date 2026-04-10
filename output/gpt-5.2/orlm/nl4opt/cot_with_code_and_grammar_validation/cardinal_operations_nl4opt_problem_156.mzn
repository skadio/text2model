% Parameters
int: min_images = 10000;
int: rate_special = 60;      % images per hour
int: rate_common  = 40;      % images per hour
int: cost_special = 100;     % $ per hour
int: cost_common  = 72;      % $ per hour

% Variables
var 0..min_images: img_special;
var 0..min_images: img_common;

% Constraints
constraint img_special + img_common >= min_images;

% At least a third of the work to specialized: img_special >= (img_special+img_common)/3
% Linearized as: 3*img_special >= img_special + img_common  <=>  2*img_special >= img_common
constraint 2 * img_special >= img_common;

% Objective
solve minimize
  (cost_special * img_special) div rate_special
+ (cost_common  * img_common ) div rate_common;