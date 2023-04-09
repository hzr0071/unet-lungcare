function DLR(foldername,logo,net)
% foldername='ldd';
 fig=waitbar(0,"DLM-hzr正在启动，请等待!");
 
outfolder=[foldername,'result'];
mkdir(outfolder)

imds=dataload(foldername);
miniBatchSize = 1;


mbq = minibatchqueue(imds,...
    "MiniBatchSize",miniBatchSize,...
    "MiniBatchFcn", @preprocessMiniBatch,...
    "MiniBatchFormat","SSCB");






% Loop over mini-batches.
i=0;
%  dlnet=dlnetwork(lgraph_1);
namelist=dir(foldername);

tic;
total=size(imds.UnderlyingDatastores{1, 1}.Files,1);
while hasdata(mbq)
    i=i+1;
msg=sprintf("正在处理第%d张/共%d张,不要关闭此窗口",i,total);
    % Read mini-batch of data.
    waitbar(i/total,fig,msg);
    dlX = next(mbq);
       
    % Make predictions using the predict function.
    dlYPred = predict(net,dlX);
    a=extractdata(dlYPred);
     a=gather(a);
    
     
%       figure(1);imshow(img,[]);


     outputname= namelist(i+2).name;
     outputinfo=dicominfo(fullfile(foldername,namelist(i+2).name));
     outputinfo.SeriesInstanceUID=[outputinfo.SeriesInstanceUID,'01'];
     outputinfo.SeriesNumber=outputinfo.SeriesNumber+1000;
     outputinfo.SeriesDescription=[outputinfo.SeriesDescription,logo];

dicomwrite(double(a(:,:,1,1))/16,fullfile(outfolder,outputname),outputinfo);
    
  
end
waitbar(1,fig,"已完成！");
toc

end

function X = preprocessMiniBatch(data)    
    % Extract image data from cell and concatenate
    X = cat(4,data{:});
    
    % Normalize the images.
   
end