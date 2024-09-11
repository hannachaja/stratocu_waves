function output1 = hanna_legend_testing(img,spec, Scales, scale, angle)
 % Overlay wavelet power on image 
    figure(1)
    imshow(img); colorbar; axis on
    
    hold on

   % factor = Scales(scale)/Scales(1);


    if angle==1 
        contour( (abs(spec(:,:,scale,angle))*factor) .^2 , EdgeColor = 'red' );
        legend("11pm")
    end

    if angle==2
        contour( (abs(spec(:,:,scale,angle))*factor) .^2 , EdgeColor = 'yellow' );
        legend("10pm")
    end

    % Adjust contour levels by factor (for real/imag), factor^2 (for power


    % Real part is crests and trofs, imag is gradients, abs is a magnitude map 
    %contour( real(spec(:,:,scale,angle)), LevelList=posLevels*factor, EdgeColor='red' );
    %contour( real(spec(:,:,scale,angle)), LevelList=negLevels*factor, EdgeColor='blue' );
    
    % "power" is amplitude abs() squared 
    %contour( (abs(spec(:,:,scale,angle))*factor) .^2 );

end

% a set of Colors for each Angle
% Angles(0)='red';
% Angles(1)='yellow';
% Angles(2)='green';
% Angles(3)='cyan';
% Angles(4)='blue';
% Angles(5)='magenta';
% Angles(6)='white';
% Angles(7)='black';