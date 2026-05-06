%%% Probe the Cauchy cwt for its properties 
%%% First reveal the mother function (cwt of a point)

% Define the size of the array
arraySize = 300;
image = zeros(arraySize, arraySize);

% Set a single pixel to 1 (center of the image for best visualization)
image(arraySize/2, arraySize/2) = 1;

% Pick a NW-SE angle and Scale for visual pleasure
Angles = 0: pi/4 ;
Scales = 20 ;

cwtCauchy = cwtft2(image,wavelet="cauchy",scales=Scales, angles=Angles);
spec = squeeze( cwtCauchy.cfs );

% Create the isosurface plot of real, imaginary
figure(1);
t = tiledlayout(1, 3, 'TileSpacing', 'tight');

nexttile
mesh( real(spec) ); title('a) Cauchy real part'); axis off;
lighting phong
camlight

nexttile
mesh( imag(spec) ); title('b) Cauchy imaginary part'); axis off;
lighting phong
camlight


%%%% How many angles is enough, for the Cauchy case? 
% Let's try it for a single line pattern 
nexttile
image(arraySize/2, :) = 1;
Scales = 10;
Angles = 0:pi/100:pi ;

cwtCauchy = cwtft2(image,wavelet="cauchy",scales=Scales, angles=Angles);
spec = squeeze( cwtCauchy.cfs );

% plot( squeeze(real(spec(150,150,:))) );
projection = squeeze(real(spec(150,150,:)));
stem( Angles*180/pi, projection/max(projection) ); 
title('c) angle resolution for line, pure wave'); xlabel('degrees')
xlim([60 120])
hold on; 


% Try it for a sinusoidal stripes pattern: wavenumber 10 in 512, scale 25
arraySize2 = 512;
% Create the x and y coordinate arrays
x = 1:arraySize2;
y = 1:arraySize2;
[X, Y] = meshgrid(x, y);
stripes = sin(2 * pi * 10 * Y / arraySize2);

%figure();
%contourf(stripes); colorbar(); 

cwtCauchy = cwtft2(image,wavelet="cauchy",scales=25, angles=Angles);
spec = squeeze( cwtCauchy.cfs );

projection = squeeze(real(spec(256,256,:)));
stem( Angles*180/pi, projection/max(projection) ); %#title('d) angle resolution for pure wave'); xlabel('degrees')
xlim([60 120])

