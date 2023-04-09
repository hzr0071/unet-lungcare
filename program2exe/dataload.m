function out1=dataload(inputdir)

inputlist=getfullfile(inputdir);


imdsinput= imageDatastore(inputlist,FileExtensions='.dcm',ReadFcn=@(x)dicomread(x),ReadSize=500);




out1=transform(imdsinput,@trans);





end


function out=trans(in)
out=cell(size(in));
for i=1:size(in,1)
    in{i}=double(in{i}>0).*double(in{i});
out{i}=in{i}/4096;
end

end


function list=getfullfile(inputdir)

namelist=dir(inputdir);

list={};
for i=3:size(namelist,1)
list{i-2}=fullfile(inputdir,namelist(i).name);
end
end
