
#include "lexer.h"

#define setwName  15

// ...................................................................... printFile

void Lexer::printFile(void)
{
    std::cout << " File Name :: " << fileInputName ;
    std::cout << " \n :: \n" << source ;
}

// ...................................................................... get char

sym_t   Lexer::getChar( void )
{
    if(fDebug)fileDebug << "\nLexer::"<<std::setw(setwName)<<"getChar -> ";
    
    if (index+1>=source.size()) 
    {
        c0=0;c1=0;
        if(fDebug)fileDebug << "return sym=sym_end ;";
        return sym=sym_end ;
    }
 
    if (source.at(index+0)=='\r')
    {
        ++index;
    }
 
    c0 = source.at(index+0);
    c1 = source.at(index+1); 

    ++index ;
    ++col   ; 

    if ( c0 == '\0' ) 
    {
        if(fDebug)fileDebug << "return sym=sym_end ;";
        return sym=sym_end ;
    }

    if ( c0 == '\n' ) { col=1; row++ ; } ;

    if ( c0 == '\t' ) { col+=tabSize ; } ;

    lev = ( col  + tabSize ) % tabSize ;    // level

    sym=sym_char;

    if(fDebug)fileDebug << "return sym=sym_char [ " << sym << " ] " << "[" << std::setw(setwName) << Token::outputSpecialCharInChar(c0) << "]";
    
    return sym ;
}

// ...................................................................... make Token

size_t   Lexer::makeToken( void )
{
    if(fDebug)fileDebug << "\nLexer::"<<std::setw(setwName)<<"makeToken -> ";

    token_t* t = new token_t ;

    t->fileInputName = fileInputName ;
    t->row           = row           ;
    t->col           = col-1         ;
    t->sym           = sym           ;
    t->token         = token         ;
    t->lev           = lev           ;

    t->integer         = 0      ;
    t->real            = 0.0    ;
    t->id              = ""     ;
    t->car             = c0     ;
    t->stringa         = ""     ;
   // char            aFloat5[5]      ;      // float c64
    t->float5          = ""     ;
    
    Token::vToken.push_back(t);

    if(fDebug)fileDebug << "return Token::vToken.size(); [ " << Token::vToken.size() << " ] " ;
    
    return Token::vToken.size();
}

// ...................................................................... is blank

bool Lexer::isBlank(void)
{
    switch(c0)
    {
        case ' '    :
        case '\t'   :
        case '\n'   :
        case '\r'   :
        case '\v'   :
        case '\f'   :
            return true;
        break;
        default:
            return false;
        break;
    }
    return false;
}

inline
sym_t   Lexer::ungetChar( void )
{
    if(fDebug)fileDebug<<"\nungetchar()";
    --index;
    return sym;
}

inline
void Lexer::skipBlank(void)
{
    while(isBlank())    getChar();
    //--index;
    ungetChar();
}

inline
void Lexer::skipLine(void)
{
    while ( getChar()!=sym_end ) if ( c0=='\n' ) break;
    
    getChar(); // skip \n
    
}
inline
void Lexer::skipDoubleComment(void)
{

    do {
        
    getChar();
    
    if ( sym==sym_eof ) { std::cout << " EOF in comment"; exit(0); } 
    
    } while ( c0!='*' && c1!='/' );
    
    // c0 = *
    // c1 = /
    getChar(); // skip c0
    getChar(); // skip c1
}
// ...................................................................... scan

sym_t   Lexer::scan_internal( void )
{
    token="";
    
    // ............................................. get character ;
    
    getChar();
    
    // ............................................. skip blank and remarks
    
    if ( isBlank()                ) {   skipBlank();  return sym;  } ;
 
    if ( c0==';'                  ) {   skipLine();   return sym;  } ;
 
    if (( c0=='/' ) && ( c1=='/' )) {   skipLine();   return sym;  } ;

    if (( c0=='/' ) && ( c1=='*' )) {   skipDoubleComment();   return sym;  } ;
    
    // ............................................. make character ;

    token.push_back( c0 ) ;
    
    makeToken();
    
    //
    
    return sym;
}

sym_t   Lexer::scan( void )
{
    
    while ( scan_internal()!=sym_end)
    {

    }
    
    if ( fDebug == true ) Token::print( fileInputName ) ;
    
    return sym;
}

#undef  fileDebug_setw
