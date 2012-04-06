
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Matrix %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pinky_left = start_of_palm(2);
pinky_right = pinky_left+10;
pinky_bottom = start_of_palm(1)-palm_height;
pinky_top = pinky_bottom-30;
pinky_mat = object_image(pinky_top:pinky_bottom, pinky_left:pinky_right);

ring_left = pinky_right;
ring_right = ring_left+10;
ring_bottom = pinky_bottom-5; % ring_offset
ring_top = ring_bottom-30;
ring_mat = object_image(ring_top:ring_bottom, ring_left:ring_right);

middle_left = ring_right;
middle_right = middle_left+10;
middle_bottom = ring_bottom-5; % middle_offset
middle_top = middle_bottom-30;
middle_mat = object_image(middle_top:middle_bottom, middle_left:middle_right);

index_left = middle_right;
index_right = index_left+13;
index_bottom = middle_bottom-5; % index_offset
index_top = index_bottom-20;
index_mat = object_image(index_top:index_bottom, index_left:index_right);

thumb_left = end_of_palm(2)+10;
thumb_right = thumb_left+30;
thumb_bottom = end_of_palm(1); % thumb_offset
thumb_top = thumb_bottom-30;
thumb_mat = object_image(thumb_top:thumb_bottom, thumb_left:thumb_right);