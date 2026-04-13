% Parameters
int: total_images = 10000;                 % Minimum number of images to annotate
int: rate_special = 60;                    % Images per hour (specialized company)
int: rate_common  = 40;                    % Images per hour (common company)
int: cost_special = 100;                   % Dollars per hour (specialized company)
int: cost_common  = 72;                    % Dollars per hour (common company)
int: min_special_fraction_num = 1;         % At least 1/3 specialized (numerator)
int: min_special_fraction_den = 3;         % At least 1/3 specialized (denominator)

% Variables
var 0..total_images: images_special;       % Images assigned to specialized company
var 0..total_images: images_common;        % Images assigned to common company

var float: hours_special;                  % Hours worked by specialized company
var float: hours_common;                   % Hours worked by common company

var float: total_cost;                     % Total outsourcing cost

% Constraints
% --- Dataset size requirement ---
constraint images_special + images_common >= total_images;

% --- Minimum specialized allocation requirement (at least 1/3 of total work) ---
% Cross-multiplied to avoid division:
% images_special / (images_special + images_common) >= 1/3
constraint
  min_special_fraction_den * images_special >=
  min_special_fraction_num * (images_special + images_common);

% --- Hours definition based on annotation rates ---
constraint hours_special = int2float(images_special) / int2float(rate_special);
constraint hours_common  = int2float(images_common)  / int2float(rate_common);

% --- Total cost definition based on hourly costs ---
constraint total_cost =
  hours_special * int2float(cost_special) +
  hours_common  * int2float(cost_common);

% Objective
solve minimize total_cost;