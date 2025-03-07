clc;clear;close all;
vid = VideoReader('16.mp4');

vidWidth = vid.Width;
vidHeight = vid.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

%Read every frames
frames = {};
numFrames = get(vid,'NumberOfFrames');
for k=1:numFrames
    frames{k} = read(vid,k);
    cropped{k} =imcrop(frames{k},[676.5 130.5 208 258]);
    %current ideal head position
    %[459.5 120.5 433 276]
    
    %current best head position
    %[676.5 130.5 208 258]
end


% detect={};
%Filter Viola-Jones
for x = 1:numFrames
    CurrentFrame = uint8(cropped{x});
    faceDetector = vision.CascadeObjectDetector;
    I = CurrentFrame;
    bboxes{x} = step(faceDetector, I);
    if ~isempty(bboxes{x})
        szbox = size(bboxes{x},[1]);
        for y = 1:szbox
            %crop gambar
            A = imcrop(CurrentFrame,bboxes{x}(y,:));

            %save gambar
            imwrite(A,strcat('16\frame-',num2str(x),'-',num2str(y),'.png')); 
        end
    end
    IFaces = insertObjectAnnotation(I, 'rectangle', bboxes{x}, 'Face');
    mov(x).cdata = IFaces;
%     figure, imshow(IFaces), title('Detected faces');
end

% %validasi ada mata atau tidak
% LefteyeDetector = vision.CascadeObjectDetector('LeftEye');
% RighteyeDetector = vision.CascadeObjectDetector('RightEye');
% 
%     for i = 1:numFrames
%         writeVideo(newVid,mov(i));
%     end;
% I = imread('visionteam.jpg');
% Leftbboxes = step(LefteyeDetector, I);
% Rightbboxes = step(RighteyeDetector, I);
% 
% Ieye = insertObjectAnnotation(I, 'rectangle', Leftbboxes, 'Left eye');
% Ieye = insertObjectAnnotation(Ieye, 'rectangle', Rightbboxes, 'Right eye');
% figure, imshow(Ieye), title('Detected faces');

%show video
hf = figure;
set(hf,'position',[400 200 vidWidth vidHeight]);

movie(hf,mov,2,vid.FrameRate);

% %export video
% newVid = VideoWriter('coba.mp4','MPEG-4');
% newVid.FrameRate = 24;
% newVid.Quality = 100;
% open(newVid)
%     for i = 1:numFrames 
%         writeVideo(newVid,mov(i));
%     end;
% close(newVid)

disp('done');

close