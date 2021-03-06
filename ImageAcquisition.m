
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Webcam Capture Code %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Image acquisition
% Octave Incompatible
                                             
DELAY=3;
sign_counter = 0;

while(true)
  pause(DELAY);
  sign_video = videoinput('winvideo', 1);
  set(sign_video, 'ReturnedColorSpace', 'RGB');
  preview(sign_video);
  start(sign_video);
  sign_capture = getdata(vid,1);
  figure(1);
  imshow(sign_capture);
  sign_capture_file = sprintf('capture%d.jpg', sign_counter);
  imwrite(sign_capture, sign_capture_file);
  stoppreview(sign_video);
  sign_counter = sign_counter + 1;			      
end

