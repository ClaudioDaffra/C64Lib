
#include "token.h"

std::vector<token_t*>   Token::vToken     ;


int Token::Delete( void )
{
    std::vector<token_t*>::iterator itv ;

    std::cout << "\n ~ Token Delete. [ " << Token::vToken.size() << " ] \n" ;

    for( itv = Token::vToken.begin(); itv != Token::vToken.end(); itv++ )
    {
        delete *itv ;
    }
    
    return 0;
}

char    Token::outputSpecialCharInChar( char carattere )
{
    if ( carattere==0 ) return 0;
    
    // \r viene saltato \f \v \t \f \' \" \\ vengono trasformati
    char wchar = carattere ;
    
    switch ( carattere ) 
    {
        case '\a'     : wchar = 'A'; break  ;
        case '\n'     : wchar = 'N'; break  ;
        case '\t'     : wchar = 'T'; break  ;
        case '\v'     : wchar = 'V'; break  ;
        case '\f'     : wchar = 'F'; break  ;
        case '\''     : wchar = '\''; break ;
        case '\"'     : wchar = '\"'; break ;
        case '\\'     : wchar = '\\'; break ;
        default       : break;
    } 

    return wchar ;
}

char*    Token::outputSpecialCharInString( char* token )
{
    if ( token == NULL ) { token[0]=0; return token; }
    
    for ( size_t i=0; i < strlen( token ) ; i++ )
    {
        token[i] = outputSpecialCharInChar( token[i] ) ;
    }
    return token ;
}

int Token::print( std::string fileInputName )
{
    std::string fileName = fileInputName+".token" ;
    
    FILE*   pFileOutputToken = fopen(fileName.c_str(),"w+");

    if (pFileOutputToken==NULL) 
    {
        //std::cout << "Token Error opening file debug";
        $lexer( fatal,openFile,errUnknown,0,0,fileName,"Token::print -> (pFileOutputToken==NULL)");
        
        return -1 ;
    }

    std::vector<token_t*>::iterator itv ;

    fprintf ( pFileOutputToken , "\nToken :: \n" ) ;
    
    for( itv = Token::vToken.begin(); itv != Token::vToken.end(); itv++ )
    {
       if ( (*itv)->sym == sym_end ) continue;
            
        fprintf ( pFileOutputToken,"\n");
        
        const char*       strcTemp = ((*itv)->fileInputName).c_str() ;
        unsigned int      strcLen  = strlen( strcTemp ) ;
        
        // file name
        
        if ( strcLen > 20 )
            fprintf ( pFileOutputToken,"[...%-17.17s]" ,&strcTemp[strcLen-17] ) ;
        else
            fprintf ( pFileOutputToken,"[%-20.20s]"    ,strcTemp ) ;
        
        // row col

        fprintf ( pFileOutputToken , " [%03d,%03d] lev(%02d) len(%02d) sym(%03d) "
        ,    (uint32_t)(*itv)->row
        ,    (uint32_t)(*itv)->col
        ,    (uint32_t)(*itv)->lev
        ,    (uint32_t)(*itv)->token.length()
        ,    (uint32_t)(*itv)->sym
        ) ;

        
        fprintf ( pFileOutputToken , " token { %-20.20s } "
            ,Token::outputSpecialCharInString((char*)((*itv)->token).c_str()) );
        
        switch((*itv)->sym)
        {
            case sym_end:
                fprintf ( pFileOutputToken , " END "                                            );
            break;
            case sym_eof:
                fprintf ( pFileOutputToken , " EOF "                                            );
            break;

            case sym_char:
                fprintf ( pFileOutputToken , " char(%c) ", outputSpecialCharInChar((*itv)->car) );
            break;
 
            case sym_string:
                fprintf ( pFileOutputToken , " string(%s) ", ((*itv)->stringa).c_str()          );
            break;

            case sym_id:
                fprintf ( pFileOutputToken , " id(%s) ", ((*itv)->id).c_str()                   );
            break;
            case sym_integer:
                #if defined(_MSC_VER)
                    fprintf ( pFileOutputToken , " -> integer[[%lld]]",(*itv)->integer          ) ;
                #else
                    fprintf ( pFileOutputToken , " -> real   [[%ld]]" ,(*itv)->integer          ) ;
                #endif
            break;
            case sym_real:
                    fprintf ( pFileOutputToken , " float5 [ %s ] "  ,((*itv)->float5).c_str()   ) ; 
                    fprintf ( pFileOutputToken , " -> [[%.5g]]"     ,(*itv)->real               ) ;
            break;
 
            default:
                fprintf ( pFileOutputToken , " default [[%d]]"      ,(*itv)->sym                ) ;
            break;
        }
 

        
    }
 
    fprintf ( pFileOutputToken , "\n\nToken :: End." ) ;
 
    fprintf ( pFileOutputToken , "\n" ) ;
    
    fclose  ( pFileOutputToken ) ;

    return 0 ;

}
