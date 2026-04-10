% Parameters
int: min_images = 10000;                 % Minimum number of images to annotate

int: rate_spec = 60;                     % Specialized company annotation rate (images/hour)
int: rate_common = 40;                   % Common company annotation rate (images/hour)

int: cost_per_hour_spec = 100;           % Specialized company cost ($/hour)
int: cost_per_hour_common = 72;          % Common company cost ($/hour)

% Variables
var 0..min_images: images_spec;          % Number of images annotated by specialized company
var 0..min_images: images_common;        % Number of images annotated by common company

var 0..min_images: total_images;         % Total images annotated (>= min_images)

var 0.0..1.0e9: hours_spec;              % Hours purchased from specialized company
var 0.0..1.0e9: hours_common;            % Hours purchased from common company

var 0.0..1.0e12: total_cost;             % Total cost to minimize

% Constraints

% --- Total images requirement ---
constraint
  total_images = images_spec + images_common;

constraint
  total_images >= min_images;

% --- Throughput / hours linkage (images = rate * hours) ---
% Use linear equalities; hours can be fractional.
constraint
  images_spec = rate_spec * hours_spec;

constraint
  images_common = rate_common * hours_common;

% --- Allocation policy: at least one third of work to specialized company ---
constraint
  3 * images_spec >= total_images;

% --- Total cost computation ---
constraint
  total_cost = cost_per_hour_spec * hours_spec + cost_per_hour_common * hours_common;

% Objective
solve minimize total_cost;