function GitComiiter(message)
 if nargin < 1
     message = 'AutoMaticUpdate'
 end
 
!git add .
eval(['!git commit -m "',message,'"'])
!git push origin master

 end