% Parameters
int: min_images = 10000;

int: rate_special = 60;    % images per hour
int: rate_common  = 40;    % images per hour

int: cost_special = 100;   % dollars per hour
int: cost_common  = 72;    % dollars per hour

% Variables
var 0..min_images: img_special;
var 0..min_images: img_common;

var 0..min_images: total_images;

var 0..1000000: total_cost; % safe upper bound

% Constraints
constraint total_images = img_special + img_common;
constraint total_images >= min_images;

% At least a third of the work must be allocated to the specialized company:
% img_special / total_images >= 1/3  <=>  3*img_special >= total_images
constraint 3 * img_special >= total_images;

% Hours needed (rounded up), linked to image allocations
var 0..1000000: hours_special;
var 0..1000000: hours_common;

constraint hours_special = (img_special + rate_special - 1) div rate_special;
constraint hours_common  = (img_common  + rate_common  - 1) div rate_common;

constraint total_cost = cost_special * hours_special + cost_common * hours_common;

% Objective
solve minimize total_cost;