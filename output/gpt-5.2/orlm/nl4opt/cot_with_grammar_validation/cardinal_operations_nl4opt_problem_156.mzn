% Parameters
int: min_images = 10000;
int: rate_spec = 60;      % images per hour
int: rate_common = 40;    % images per hour
int: cost_spec = 100;     % dollars per hour
int: cost_common = 72;    % dollars per hour

% Variables
var 0..min_images: imgs_spec;
var 0..min_images: imgs_common;

% Constraints
constraint imgs_spec + imgs_common >= min_images;

% At least a third of the work must be allocated to the specialized company:
% 3*imgs_spec >= imgs_spec + imgs_common  <=>  2*imgs_spec >= imgs_common
constraint 3 * imgs_spec >= imgs_spec + imgs_common;

% Objective
solve minimize cost_spec * imgs_spec * rate_common + cost_common * imgs_common * rate_spec;