
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Debug %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DEBUG = true;
if(DEBUG)
  figure(2)
  imshow(object_image)
  hold on
  plot([thumb_left thumb_right],[thumb_bottom thumb_top],'r')
  plot([index_left index_right],[index_bottom index_top],'g')
  plot([middle_left middle_right],[middle_bottom middle_top],'b')
  plot([ring_left ring_right],[ring_bottom ring_top],'c')
  plot([pinky_left pinky_right],[pinky_bottom pinky_top],'m')
  plot([start_of_palm(2) end_of_palm(2)],[start_of_palm(1) end_of_palm(1)],'k')
  hold off
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Display %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
subplot(2,5,1:5)
imshow(object_image)
title('Hand')

subplot(256)
imshow(pinky_mat)
title('Pinky')

subplot(257)
imshow(ring_mat)
title('Ring')

subplot(258)
imshow(middle_mat)
title('Middle')

subplot(259)
imshow(index_mat)
title('Index')

subplot(2,5,10)
imshow(thumb_mat)
title('Thumb')

