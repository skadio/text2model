% Parameters
int: num_pieces;                          % Number of pieces in the concert
int: num_players;                         % Number of orchestra players

set of int: PIECES  = 1..num_pieces;      % Index set for pieces / positions
set of int: PLAYERS = 1..num_players;     % Index set for players

array[PIECES] of int: duration;           % Duration of each piece (e.g., minutes)
array[PLAYERS, PIECES] of int: rehearsal; % 1 if player p plays in piece i, else 0

% Variables
array[PIECES] of var PIECES: position_of_piece;  % position_of_piece[i] = position of piece i in the order
array[PIECES] of var PIECES: piece_at_position;  % piece_at_position[pos] = which piece is at position pos

array[PLAYERS] of var PIECES: first_pos;         % first position in which player p participates
array[PLAYERS] of var PIECES: last_pos;          % last position in which player p participates

array[PLAYERS, PIECES] of var 0..1: plays_at_pos; % plays_at_pos[p,pos] = 1 if p plays at position pos

array[PIECES] of var int: start_time;            % start time of the piece at each position
var int: total_waiting_time;                     % objective: total waiting time over all players

% Constraints
% --- Permutation / linking between representations of the schedule ---
constraint all_different(position_of_piece);       % each piece gets a unique position
constraint all_different(piece_at_position);       % each position has a unique piece
constraint inverse(position_of_piece, piece_at_position); % consistent inverse mapping

% --- Who plays at each position (derived from piece scheduled there) ---
constraint
  forall(p in PLAYERS, pos in PIECES) (
    plays_at_pos[p, pos] = rehearsal[p, piece_at_position[pos]]
  );

% --- Start times based on cumulative durations in the chosen order ---
constraint start_time[1] = 0;
constraint
  forall(pos in 2..num_pieces) (
    start_time[pos] = start_time[pos-1] + duration[piece_at_position[pos-1]]
  );

% --- First/last position for each player (based on where they play) ---
% Ensure each player participates in at least one piece (so first/last are well-defined)
constraint
  forall(p in PLAYERS) (
    sum(i in PIECES)(rehearsal[p,i]) >= 1
  );

% first_pos[p] is the earliest position with plays_at_pos[p,pos] = 1
constraint forall(p in PLAYERS) ( plays_at_pos[p, first_pos[p]] = 1 );
constraint
  forall(p in PLAYERS, pos in PIECES) (
    (pos < first_pos[p]) -> (plays_at_pos[p, pos] = 0)
  );

% last_pos[p] is the latest position with plays_at_pos[p,pos] = 1
constraint forall(p in PLAYERS) ( plays_at_pos[p, last_pos[p]] = 1 );
constraint
  forall(p in PLAYERS, pos in PIECES) (
    (pos > last_pos[p]) -> (plays_at_pos[p, pos] = 0)
  );

% --- Total waiting time definition ---
% Waiting time for player p = (time present) - (time playing)
% time present = end of last piece they play - start of first piece they play
% time playing = sum of durations of pieces they play
constraint
  total_waiting_time =
    sum(p in PLAYERS)(
      ( start_time[last_pos[p]] + duration[piece_at_position[last_pos[p]]] )
      - start_time[first_pos[p]]
      - sum(pos in PIECES)( plays_at_pos[p,pos] * duration[piece_at_position[pos]] )
    );

% Objective
solve minimize total_waiting_time;