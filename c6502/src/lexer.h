
#ifndef cdLexer
#define cdLexer

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <iostream>
#include <fstream>
#include <iomanip>

#include "error.h"
#include "token.h"

class Lexer
{
    private:
        
        std::string     fileInputName   =   ""      ;   // file sorgente
        std::string     source          =   ""      ;   // sorgente ( stringa )
        
        std::ifstream   fileInput                   ;
        bool            fDebug          =   false   ;
        std::ofstream   fileDebug                   ;

        // char

        size_t  index                               ;  // indice della stringa (-1) iniziale (getChar++)
        char    c0                                  ;  // character 
        char    c1                                  ;  // look ahead
        char    c2                                  ;  // extra
        sym_t   getChar( void )                     ;  // get char (C0) and lookahead (C1)
        sym_t   ungetChar( void )                   ;  // un get char (C0) and lookahead (C1)
        
        // token

        sym_t       sym                             ;  // simbolo attuale
        size_t      row                             ;  // riga
        size_t      col                             ;  // colonna
        size_t      lev                             ;  // python level
        std::string token                           ;  // token
        size_t      makeToken( void )               ;  // make Token
        bool        isBlank(void)                   ;  // is blank character
        void        skipBlank(void)                 ;  // skip blank
        void        skipLine(void)                  ;  // skip line
        void        skipDoubleComment(void)         ;  // skip C comment
        sym_t       scan_internal( void )           ;  // scanner

    public:
    
        sym_t   scan( void )                        ;  // lexer scan !
        
        size_t  tabSize                             ;  // default=4
        
        Lexer( std::string _fileInputName,bool _fDebug=false )
        {
            // init file
            fileInputName = _fileInputName ;
            fDebug        = _fDebug ;
            
            // init token
            index               =   0      ;
            row                 =   1      ;
            col                 =   1      ;
            tabSize             =   4      ;
            sym                 =   sym_end ;
            
            // ................................................................ file debug
            
            if ( fDebug == true )
            {
                fileDebug.open( fileInputName+".lexer" , std::ios::out );
                if (fileDebug.fail()) 
                {
                    //std::cout << "LExer Error opening file debug";
                    $lexer( fatal,openFile,errUnknown,0,0,fileInputName,"fileDebug.fail()");
                }
                else
                {
                    fileDebug << "\nLexer ::";
                }
            }

            // ................................................................ read source

            fileInput.open(fileInputName) ;

            if (fileInput.fail()) 
            {
                //std::cout << "Error opening file";
                $lexer( fatal,openFile,errUnknown,0,0,fileInputName,"fileInput.fail()");
            }
            else
            {
                if(fileInput) 
                {
                    std::ostringstream ss;
                    ss << fileInput.rdbuf();  
                    source = ss.str();
                    source.push_back(0);
                    source.push_back(0);
                    source.push_back(0);
                    
                };
            }
        }
        
        ~Lexer()
        {
            if ( fDebug == true )
            {
                fileDebug << "\nLexer :: end";
                fileDebug << "\n";
                fileDebug.close();
            }
        }
        
        void printFile(void);
        
} ;


#endif
