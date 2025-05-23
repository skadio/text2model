% Parameters
int: num_pieces;
int: num_players;

array[1..num_pieces] of int: duration;
array[1..num_players, 1..num_pieces] of int: rehearsal; % 1 ⇔ player involved in piece

% Derived constants
int: total_duration = sum(i in 1..num_pieces)(duration[i]);
int: BIG             = total_duration + 1;

array[1..num_players] of int: play_duration =
  [ sum(i in 1..num_pieces)(rehearsal[p,i] * duration[i]) | p in 1..num_players ];

% Variables
array[1..num_pieces]  of var 0..total_duration: start;          % start time of each piece
array[1..num_players] of var 0..total_duration: first_start;    % first time a player must be present
array[1..num_players] of var 0..total_duration: last_end;       % last time a player must be present
array[1..num_players] of var 0..total_duration: waiting;        % waiting time of each player

% Constraints
include "globals.mzn";

% 1. Pieces are rehearsed sequentially (no overlap)
constraint disjunctive(start, duration);

% 2. Finish within the overall horizon
constraint forall(i in 1..num_pieces)(
  start[i] + duration[i] <= total_duration
);

% 3. Earliest and latest presence for each player
constraint
  forall(p in 1..num_players) (
    minimum(first_start[p],
            [ start[i] + (1 - rehearsal[p,i]) * BIG
              | i in 1..num_pieces ]) /\
    maximum(last_end[p],
            [ start[i] + duration[i] - (1 - rehearsal[p,i]) * BIG
              | i in 1..num_pieces ])
  );

% 4. Waiting time definition (non-negative by bounds)
constraint
  forall(p in 1..num_players)(
    waiting[p] = last_end[p] - first_start[p] - play_duration[p]
  );

% Objective
solve minimize sum(p in 1..num_players)(waiting[p]);