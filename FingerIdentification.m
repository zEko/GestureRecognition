
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Identification %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finger_mat = zeros(1,5);
pinky = 1;
ring = 2;
middle = 3;
index = 4;
thumb = 5;

pinky_total = numel(pinky_mat);
pinky_true = numel(find(pinky_mat == 1));
if(pinky_true > 50)
  finger_mat(pinky) = 1;
end

ring_total = numel(ring_mat);
ring_true = numel(find(ring_mat == 1));
if(ring_true > 50)
  finger_mat(ring) = 1;
end

middle_total = numel(middle_mat);
middle_true = numel(find(middle_mat == 1));
if(middle_true > 50)
  finger_mat(middle) = 1;
end

index_total = numel(index_mat);
index_true = numel(find(index_mat == 1));
if(index_true > 50)
  finger_mat(index) = 1;
end

thumb_total = numel(thumb_mat);
thumb_true = numel(find(thumb_mat == 1));
if(thumb_true > 90)
  finger_mat(thumb) = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger output %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:11
  if finger_mat == finger_db(i).mat
    sprintf('\nThe sign is %s. \n', finger_db(i).name)
  end
end
