/* REXX */                                                                      
arg options                                                                     
trace 'o'                                                                       
parse var options command                                                       
parse var command opercmd                                                       
                                                                                
opercmd = strip(opercmd,'L')                                                    
if opercmd == '' then do                                                        
    say 'Invalid command.  Must not be blank'                                   
    exit 12                                                                     
end                                                                             
                                                                                
cmd.1 = opercmd                                                                 
cmd.0 = 1                                                                       
                                                                                
rc=isfcalls('ON')                                                               
/* Use SDSF Interface to issue console command */                               
Address SDSF ISFSLASH "("cmd.") (WAIT)"                                         
                                                                                
if rc<>0 then do                                                                
     say 'Bad return from isfslash.  rc is ' rc                                 
     Exit rc                                                                    
end                                                                             
                                                                                
do ix=1 to isfulog.0                                                            
    say isfulog.ix                                                              
end                                                                             
                                                                                
rc=isfcalls('OFF')

