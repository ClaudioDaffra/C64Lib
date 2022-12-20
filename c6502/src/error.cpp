
#include "error.h"
#include <string.h>

uint32_t                Error::kError  =0   ;
uint32_t                Error::kWarning=0   ;
std::vector<errLog_t*>  Error::vErrLog      ;


// ................................................... sender

sender_t sender[] =
{
    { "loader"      } ,
    { "lexer"       } ,
    { "parser"      } ,
    { "AST"         } ,
    { "node"        } ,
    { "assembler"   } ,
    { "VM"          } ,
    { "scanner"     } ,
    { "cpp"         } ,
} ;

// ................................................... type

type_t type[] =
{
    { "! Info"       } ,
    { "Warning !"    } ,
    { "? Error"      } ,
    { "?? Critical"  } ,
    { "!! Fatal"     } ,
    { "## Internal"  } ,
} ;

// ................................................... action

action_t action[] =
{
    { "no Error"                 } ,
    { "no Action"                } ,
    { "check if file exists"     } ,
    { "scan comment"             } ,
    { "push token text"          } ,
    { "scanning Number"          } ,
    { "convert token to number"  } ,
    { "parsing expression"       } ,
    { "open/create file"         } ,
    { "parsing ..."              } ,
    { "malloc"                   } ,
    { "dealloc"                  } ,
    { "debug"                    } ,
    { "running ..."              } ,
    { "assembling ..."           } ,
    { "scanning ..."             } ,
    { "tokenizing ..."           } ,
} ;

// ................................................... errMessage

errMessage_t errMessage[] =
{
    { "no Error"                                                                       } ,
    { "file Not Found"                                                                 } ,
    { "no input files"                                                                 } ,
    { "reached end of file"                                                            } ,
    { "found end * /  before begin / *"                                                } ,
    { "text length exceed token max size"                                              } ,
    { "unable to find numeric literal after"                                           } ,
    { "invalid argument"                                                               } ,
    { "out of range"                                                                   } ,
    { "hexadecimal floating constants require an exponent"                             } ,
    { "exponent has no digits"                                                         } ,
    { "ndx >= source.size()"                                                           } ,
    { "symbol unexpected"                                                              } ,
    { "error unknown"                                                                  } ,
    { "unexptected Token"                                                              } ,
    { "Did you mean ?"                                                                 } ,
    { "syntax error"                                                                   } ,
    { "out of memory"                                                                  } ,
    { "not implemented yet"                                                            } ,
    { "division by zero"                                                               } ,
    { "duplicate symbol name"                                                          } ,
    { "undeclared identifier"                                                          } ,
    { "lvalue required as left operand of assignment"                                  } ,
    { "expected primary-expression before"                                             } ,
    { "expected primary-expression after"                                              } ,
    { "array bound is not an integer constant before ']'"                              } ,
    { "type void not allowed"                                                          } ,
    { "was not declared in this scope"                                                 } ,
    { "invalid use of"                                                                 } ,
    { "incomplete universal chracter name"                                             } ,
} ;

// ................................................... push err log


size_t Error::pushErrLog
(
    e_sender_t          sender      ,
    e_type_t            type        ,
    e_action_t          action      ,
    e_errMessage_t      errMessage  ,
    uint32_t            rowTok      ,
    uint32_t            colTok      ,
    std::string         fileInput   ,
    std::string         extra        
)
{
    errLog_t* err = new errLog_t ;

    if ( type == type_warning ) 
        ++Error::kWarning   ;
    else
        ++Error::kError     ;

    err->sender          = sender    ;
    err->type            = type      ;
    err->action          = action    ;
    err->errMessage      = errMessage;
    err->rowTok          = rowTok    ;
    err->colTok          = colTok    ;
    err->fileInput       = fileInput ;
    err->extra           = extra     ;

    Error::vErrLog.push_back(err);
    
    return Error::vErrLog.size();
}


// ................................................... print err log

int Error::printErrLog(void)
{
    fprintf ( stderr ,"\n Error Log :: %d. \n",(int)Error::vErrLog.size() ) ;
    
	if ( ! Error::vErrLog.size() ) return 0 ;
	
    std::vector<errLog_t*>::iterator itv ;

    //fprintf ( stderr ,"\n Error Log :: \n" ) ;

    for( itv = Error::vErrLog.begin(); itv != Error::vErrLog.end(); itv++ )
    {
/*
        if ((*itv)->extra!=NULL) 
			if ( ! strcmp ( (*itv)->extra ,"EOF" ) ) 
				continue ;
*/
        fprintf ( stderr ,"\n" ) ; 
 
        if ( (*itv)->fileInput != "" )
        {
            const char* strTemp =  ((*itv)->fileInput).c_str();
            if ( strlen( strTemp ) > 20  )
                fprintf ( stderr,"[%-17.17s...]" ,strTemp );
            else
                fprintf ( stderr,"[%-20.20s]"    ,strTemp );

            if ( ( (*itv)->rowTok != 0 ) && ( (*itv)->colTok != 0 ) ) 
            {
                fprintf ( stderr ," %03d / %03d :"   ,(*itv)->rowTok,(*itv)->colTok ) ; 
            }
            fprintf ( stderr ," " ) ;
            
        }
 
        fprintf ( stderr ,"%-12s : "    , (char*) (type      [(unsigned short)   (*itv)->type        ].value).c_str() ) ; 
        fprintf ( stderr ,"%-8s : "     , (char*) (sender    [(unsigned short)   (*itv)->sender      ].value).c_str() ) ; 
        fprintf ( stderr ,"%s . "       , (char*) (action    [(unsigned short)   (*itv)->action      ].value).c_str() ) ; 
        fprintf ( stderr ,"%s "         , (char*) (errMessage[(unsigned short)   (*itv)->errMessage  ].value).c_str() ) ; 

        if ( (*itv)->extra != "" )
        {
            /*
            char* temp = gcStrDup( (char*) (*itv)->extra ) ;
            fprintf ( stderr ,": (%s)", g.outputSpecialCharInString( temp ) );
            */
            fprintf ( stderr ,": (%s)", ((*itv)->extra).c_str() ) ;
        }
        
        fprintf ( stderr ,"." ) ;  
 
    }
 
    fprintf (stderr,"\n");
    
    return 1 ;
}

int Error::Delete(void)
{
    std::vector<errLog_t*>::iterator itv ;

    std::cout << "\n ~ Error Log Delete. [ " << Error::vErrLog.size() << " ] \n" ;

    for( itv = Error::vErrLog.begin(); itv != Error::vErrLog.end(); itv++ )
    {
        delete *itv ;
    }
    
    return 0;
}