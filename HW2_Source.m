%160315007 İbrahim Caner KARTAL
close all;
clc;
clear;
a = imread('images/original.tif');
subplot(1,2,1);
imshow(a);
title('Original Picture');
I1=imread('images/7.tif');
subplot(1,2,2);
imshow(I1)
title('7.tif');


I1=medfilt2(I1);%default : 3-3

figure, imshow(I1)
title('After applied median filter');


%Determine good padding for Fourier transform
PQ = paddedsize(size(I1));

%Create Notch filters corresponding to extra peaks in the Fourier transform
H1 = notch('btw', PQ(1), PQ(2), 8, 33, 14);
H2 = notch('btw', PQ(1), PQ(2), 8, 969, 738);
%It is more beautiful "btw" than "gaussian".

%figure, imshow(fftshift(H1.*H2));

% Calculate the discrete Fourier transform of the image
F=fft2(double(I1),PQ(1),PQ(2));

% Apply the notch filters to the Fourier spectrum of the image
FS_picture = F.*H1.*H2;

% convert the result to the spacial domain.
F_picture=real(ifft2(FS_picture)); 

% Crop the image to undo padding
F_picture=F_picture(1:size(I1,1), 1:size(I1,2));

%Display the blurred image
figure, imshow(F_picture,[])
title('Blurred Image And After Applied Notch Filter');
%sharpining
Isharp1=imsharpen(F_picture);
Isharp2=imsharpen(F_picture,'Radius',2,'Amount',2);
figure, imshow(Isharp1,[])
title('After Applied Sharpening Filter');

f4 = F_picture;
f5 = Isharp1;


% Display the Fourier Spectrum 
% Move the origin of the transform to the center of the frequency rectangle.
Fc=F;
Fcf=fftshift(FS_picture);

% use abs to compute the magnitude and use log to brighten display
S1=log(1+abs(Fc)); 
S2=log(1+abs(Fcf));
%figure, imshow(S1,[])
%figure, imshow(S2,[])


for i=1:375
    for j=1:500
    if f5(i,j)+90 <= 255
        f5(i,j) = f5(i,j)+90;
    elseif f5(i,j)+90 > 255
        f5(i,j) = 255;
    end
    end
end

figure, imshow(f5,[])
title('After increased brightness');