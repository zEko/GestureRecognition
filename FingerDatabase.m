
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Database %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mat = [pinky ring middle index thumb]
finger_db(1).mat = [0 0 0 1 0];
finger_db(1).name = 'one';
finger_db(2).mat = [0 0 1 1 0];
finger_db(2).name = 'two';
finger_db(3).mat = [0 0 1 1 1];
finger_db(3).name = 'three';
finger_db(4).mat = [0 1 1 1 1];
finger_db(4).name = 'four';
finger_db(5).mat = [1 1 1 1 1];
finger_db(5).name = 'five';
finger_db(6).mat = [0 1 1 1 0];
finger_db(6).name = 'six';
finger_db(7).mat = [1 0 1 1 0];
finger_db(7).name = 'seven';
finger_db(8).mat = [1 1 0 1 0];
finger_db(8).name = 'eight';
finger_db(9).mat = [1 1 1 0 0];
finger_db(9).name = 'nine';
finger_db(10).mat = [0 0 0 0 0];
finger_db(10).name = 'none';

% False Positives
% A dirty hack for some signs
finger_db(11).mat = [0 1 0 1 0];
finger_db(11).name = 'two';
finger_db(11).mat = [0 1 0 1 1];
finger_db(11).name = 'three';


