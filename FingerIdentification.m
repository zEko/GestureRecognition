
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
pinky_threshold = 50;
pinky_true = (((numel(find(pinky_mat > 0)))/pinky_total)*100) > pinky_threshold;
if(pinky_true)
  finger_mat(pinky) = 1;
end

ring_total = numel(ring_mat);
ring_threshold = 50;
ring_true = (((numel(find(ring_mat > 0)))/ring_total)*100) > ring_threshold;
if(ring_true)
  finger_mat(ring) = 1;
end

middle_total = numel(middle_mat);
middle_threshold = 50;
middle_true = (((numel(find(middle_mat > 0)))/middle_total)*100) > middle_threshold;
if(middle_true)
  finger_mat(middle) = 1;
end

index_total = numel(index_mat);
index_threshold = 50;
index_true = (((numel(find(index_mat > 0)))/index_total)*100) > index_threshold;
if(index_true)
  finger_mat(index) = 1;
end

thumb_total = numel(thumb_mat);
thumb_threshold = 50;
thumb_true = (((numel(find(thumb_mat > 0)))/thumb_total)*100) > thumb_threshold;
if(thumb_true)
  finger_mat(thumb) = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger output %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:9
  if finger_mat == finger_db(i).mat
    sprintf('\nThe sign is %s. \n', finger_db(i).name)
  end
end
