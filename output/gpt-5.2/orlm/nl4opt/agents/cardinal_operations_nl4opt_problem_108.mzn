% Parameters
int: slices_per_min_manual = 5;        % slices/min produced by one manual slicer
int: slices_per_min_auto   = 8;        % slices/min produced by one automatic slicer
int: grease_per_min_manual = 3;        % grease units/min used by one manual slicer
int: grease_per_min_auto   = 6;        % grease units/min used by one automatic slicer
int: min_slices_required   = 50;       % minimum total slices/min required
int: max_grease_allowed    = 35;       % maximum total grease units/min allowed

% Variables
% Upper bounds: enough slicers to meet demand even if only that type is used
var 0..ceil(int2float(min_slices_required) / int2float(slices_per_min_manual)): num_manual; % # of manual slicers
var 0..ceil(int2float(min_slices_required) / int2float(slices_per_min_auto)):   num_auto;   % # of automatic slicers

% Total slicers (bounded by the sum of the above maxima)
var 0..(ceil(int2float(min_slices_required) / int2float(slices_per_min_manual))
      + ceil(int2float(min_slices_required) / int2float(slices_per_min_auto))): total_slicers; % total slicers

% Constraints
% Total slicers definition
constraint total_slicers = num_manual + num_auto;

% Production requirement: meet minimum slices per minute
constraint
  slices_per_min_manual * num_manual + slices_per_min_auto * num_auto >= min_slices_required;

% Grease usage limit: do not exceed maximum grease per minute
constraint
  grease_per_min_manual * num_manual + grease_per_min_auto * num_auto <= max_grease_allowed;

% Operational policy: manual slicers must be fewer than automatic slicers
constraint num_manual < num_auto;

% Objective
solve minimize total_slicers;