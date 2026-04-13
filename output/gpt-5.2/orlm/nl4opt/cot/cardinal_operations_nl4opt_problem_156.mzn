% Parameters (with values embedded)
int: min_images = 10000;

int: rate_spec = 60;   % images per hour
int: rate_comm = 40;   % images per hour

int: cost_spec = 100;  % $ per hour
int: cost_comm = 72;   % $ per hour

% Variables
var 0..min_images: img_spec;  % images annotated by specialized company
var 0..min_images: img_comm;  % images annotated by common company

% (Implicit) hours, derived from images and rates
var 0..min_images: hours_spec;
var 0..min_images: hours_comm;

% Constraints
constraint img_spec + img_comm >= min_images;

% At least one third of total work goes to specialized company:
% 3*img_spec >= img_spec + img_comm  <=>  2*img_spec >= img_comm
constraint 2 * img_spec >= img_comm;

% Link images to hours exactly (rates divide the assigned image counts)
constraint img_spec = rate_spec * hours_spec;
constraint img_comm = rate_comm * hours_comm;

% Objective
solve minimize cost_spec * hours_spec + cost_comm * hours_comm;