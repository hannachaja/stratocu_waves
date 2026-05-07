% Import video 
v = VideoReader("DATA/Baja_202307051401-202307052331_g18_conus_band2_vonkarmans-waves_nolabels.mp4");
video = read(v);

% red channel brightness only 
red = squeeze( video(:,:,1,:) );
% size(red) 1080, 1920, 115

frame50=red(:,:,50);
figure(1)
imshow(frame50); colorbar;



%%% Wavelet transform 

% a set of 6 Angles from 0 to pi 
Angles = 0:pi/6:pi-pi/6 ;


% a set of 10 Scales
% Scales = 5:5:50


% a LOGARITHMIC set of 10 Scales (1.2)
% Scales = [2,5,10,20,40,80,160,320,640,1000] ;
Scales = 10.^(1.2:.2:3) ;

cwtCauchy = cwtft2(frame50,wavelet="cauchy",scales=Scales, angles=Angles);

spec = squeeze( cwtCauchy.cfs );
size(spec) 

% RESULT: size 1080,1920, 10 SCALES, 8 ANGLES


% Overlay wavelet power on image 
%figure(1)
%imshow(frame50); colorbar; axis on

%hold on

%posLevels = 10:20:90; negLevels = -90:20:-10; 
%powlevels = 1000:1000:5000;


% Real part is crests and trofs, imag is gradients, abs is a magnitude map 
%contour( real(spec(:,:,10,7)), LevelList=posLevels,EdgeColor='red' );
%contour( real(spec(:,:,10,7)), LevelList=negLevels,EdgeColor='blue' );

% "power" is amplitude abs() squared 
%contour( abs(spec(:,:,10,7)).^2 );

hanna_image_with_wavelet_overlay(frame50,spec, Scales, 5, 6)