clc; clf; clear all; close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Group : r7, g21                 %%%
%%% College : RNSIT, WorldServe     %%%
%%% Project : Hand Sign recognition %%%
%%% Software : Octave               %%%
%%% Licence : GPLv3                 %%%
%%% Author : kAi                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Webcam Capture Code %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% bg = background_image
bg = imread('bg.jpg');

% image_in = sign_image
image_in = imread('hand.jpg');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Segmentation Method %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bg = rgb2ycbcr(bg);
image_in = rgb2ycbcr(image_in);
[nr nc nd] = size(image_in);

% IF AMOUNT OF (bg(LUMA)) IN SKIN COLOR SPACE
% IS > 10% OF IMAGE DO {Background Difference}
no_of_luma_pix = numel(find(bg(:,:,1) < 60));

SEGMENTATION = 1;
if (no_of_luma_pix > 0.10*(nr*nc))
  SEGMENTATION = 0;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Color Space Segmentation %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (SEGMENTATION == 1)
  skin_mat = zeros(nr, nc);
  for ir = 1:nr
    for ic = 1:nc
      if ((image_in(ir, ic, 1) > 0) && ...
	  (image_in(ir, ic, 1) < 255))% && ...
%	  (image_in(ir, ic, 2) > 30) && ...
%	  (image_in(ir, ic, 2) > 0) && ...
%	  (image_temp(ir, ic, 3) < 200) && ...
%	  (image_temp(ir, ic, 3) > 15))

        skin_mat(ir, ic) = 1;
      else
	skin_mat(ir, ic) = 0;
      end % if
    end % column loop
  end % row loop
  object_image = skin_mat;
end % end if


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Background Difference %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (SEGMENTATION == 0)
  object_image = zeros(nr,nc);
  diff_values = bg(:,:,1) - image_in(:,:,1);
  THRESHOLD = mean(max(diff_values));
  object_image = (diff_values > THRESHOLD);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Palm Finder %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MINIMUM_PALM_WIDTH = 35;
palm_height = round(0.8*MINIMUM_PALM_WIDTH);
palm_width_counter=0;

% Flags to indicate if we have found a palm candidate
palm_dimensions = [0 0];
innerbreak = false;

% Palm is in the bottom half of image
% a reduction of 10 pix would be needed from floor if the box interferes in conversion
for ir=nr-15:-1:((nr/2))
  for ic=1:nc

    % START PALM CANDIDATE
    if(object_image(ir,ic) == 1)
      palm_width_counter = palm_width_counter + 1;
    end
    % END PALM CANDIDATE
    % START PALM CONDITION
    if(palm_width_counter > MINIMUM_PALM_WIDTH)
      palm_dimensions = [ir ic];
        % we have found our palm candidate, lets break out of scan
      innerbreak = true;
      break
    end
    % END PALM CONDITION
  end
  palm_width_counter=0;
  % Need this to trick Octave
  if(innerbreak)
    break;
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Display %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
imshow(object_image)
hold on

plot(palm_dimensions(2), palm_dimensions(1), 'ro')
plot(palm_dimensions(2)-MINIMUM_PALM_WIDTH , palm_dimensions(1), 'ro')
plot(palm_dimensions(2)-(MINIMUM_PALM_WIDTH/2), palm_dimensions(1), 'r*')
plot([palm_dimensions(2), palm_dimensions(2)-MINIMUM_PALM_WIDTH], [palm_dimensions(1), palm_dimensions(1)], 'b-')

pinky_left = palm_dimensions(2)-MINIMUM_PALM_WIDTH;
pinky_right = pinky_left+10;
pinky_bottom = palm_dimensions(1)-palm_height;
pinky_top = pinky_bottom-30;
pinky_mat = object_image(pinky_top:pinky_bottom, pinky_left:pinky_right);
plot(pinky_left, pinky_bottom, 'ro')
plot(pinky_left, pinky_top, 'ro')
plot(pinky_right, pinky_bottom, 'ro')
plot(pinky_right, pinky_top, 'ro')

ring_left = pinky_right;
ring_right = ring_left+10;
ring_bottom = pinky_bottom-5; % ring_offset
ring_top = ring_bottom-30;
ring_mat = object_image(ring_top:ring_bottom, ring_left:ring_right);
plot(ring_left, ring_bottom, 'yo')
plot(ring_left, ring_top, 'yo')
plot(ring_right, ring_bottom, 'yo')
plot(ring_right, ring_top, 'yo')

middle_left = ring_right;
middle_right = middle_left+10;
middle_bottom = ring_bottom-5; % middle_offset
middle_top = middle_bottom-30;
middle_mat = object_image(middle_top:middle_bottom, middle_left:middle_right);
plot(middle_left, middle_bottom, 'bo')
plot(middle_left, middle_top, 'bo')
plot(middle_right, middle_bottom, 'bo')
plot(middle_right, middle_top, 'bo')

index_left = middle_right;
index_right = index_left+13;
index_bottom = middle_bottom-5; % index_offset
index_top = index_bottom-35;
index_mat = object_image(index_top:index_bottom, index_left:index_right);
plot(index_left, index_bottom, 'go')
plot(index_left, index_top, 'go')
plot(index_right, index_bottom, 'go')
plot(index_right, index_top, 'go')

thumb_left = palm_dimensions(2);
thumb_right = thumb_left+30;
thumb_bottom = palm_dimensions(1); % thumb_offset
thumb_top = thumb_bottom-30;
thumb_mat = object_image(thumb_top:thumb_bottom, thumb_left:thumb_right);
plot(thumb_left, thumb_bottom, 'mo')
plot(thumb_left, thumb_top, 'mo')
plot(thumb_right, thumb_bottom, 'mo')
plot(thumb_right, thumb_top, 'mo')

title('Hand with Fingers marked')
hold off;

figure(2)
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger Identification %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
finger_mat = zeros(1,5);
pinky = 1;
ring = 2;
middle = 3;
index = 4;
thumb = 5;

pinky_total = numel(pinky_mat > 0);
pinky_threshold = 40;
pinky_true = (((numel(find(pinky_mat > 0)))/pinky_total)*100) > pinky_threshold;
if(pinky_true)
  finger_mat(pinky) = 1;
end

ring_total = numel(ring_mat > 0);
ring_threshold = 60;
ring_true = (((numel(find(ring_mat > 0)))/ring_total)*100) > ring_threshold;
if(ring_true)
  finger_mat(ring) = 1;
end

middle_total = numel(middle_mat > 0);
middle_threshold = 60;
middle_true = (((numel(find(middle_mat > 0)))/middle_total)*100) > middle_threshold;
if(middle_true)
  finger_mat(middle) = 1;
end

index_total = numel(index_mat > 0)
index_threshold = 40
index_true = (((numel(find(index_mat > 0)))/index_total)*100) > index_threshold
if(index_true)
  finger_mat(index) = 1
end

thumb_total = numel(thumb_mat > 0)
thumb_threshold = 60
thumb_true = (((numel(find(thumb_mat > 0)))/thumb_total)*100) > thumb_threshold
if(thumb_true)
  finger_mat(thumb) = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Finger output %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:9
  if finger_mat == finger_db(i).mat
    printf("\nThe sign is %s. \n", finger_db(i).name)
  end
end


