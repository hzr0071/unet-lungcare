function out=dataload(start,endd,foldername)



namelis={};
for i=start:endd
   name=[foldername,'\0 (' num2str(i) ').dcm'];
   namelis{i-start+1}=name;
end
imdsinput= imageDatastore(namelis,FileExtensions='.dcm',ReadFcn=@(x)dicomread(x),ReadSize=500,Labels=namelis);



out=transform(imdsinput,@trans1);






end


function out=trans1(in)
out=cell(size(in));
for i=1:size(in,1)
out{i}=double(in{i})/4096;
end

end


