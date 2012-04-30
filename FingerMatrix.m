
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Matrix %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pinky_left = pinky_right+palm_width;
if(pinky_left > nc)
  pinky_left = nc;
end
pinky_right = end_of_palm(2) - round(palm_width/4) ;
pinky_bottom = end_of_palm(1)+palm_height;
pinky_top = pinky_bottom+palm_height;
pinky_mat = object_image(pinky_bottom:pinky_top, pinky_right:pinky_left);

ring_left = pinky_right-3;
ring_right = start_of_palm(2) + round(palm_width/2) - 5;
ring_bottom = pinky_bottom;
ring_top = ring_bottom+palm_height;
ring_mat = object_image(ring_bottom:ring_top, ring_right:ring_left);

middle_left = ring_right - 5;
middle_right = middle_left - round(palm_width/4) - round(palm_width/8);
middle_bottom = pinky_bottom;
middle_top = middle_bottom+palm_height;
middle_mat = object_image(middle_bottom:middle_top, middle_right:middle_left);

index_left = middle_right;
index_right = index_left-palm_width;
index_bottom = middle_bottom;
index_top = index_bottom+palm_height;
index_mat = object_image(index_bottom:index_top, index_right:index_left);

thumb_left = start_of_palm(2)-5;
thumb_right = thumb_left-palm_height;
if(thumb_right < 1)
  thumb_right = 1;
end
thumb_bottom = start_of_palm(1);
thumb_top = thumb_bottom+30;
thumb_mat = object_image(thumb_bottom:thumb_top, thumb_right:thumb_left);
