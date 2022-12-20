
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstddef>

#include "token.h"
#include "lexer.h"
#include "error.h"
#include "parser.h"

using namespace std;

int main(int argc,char* argv[]) 
{
   std::string  fileInputName   =   "stdin" ;
   std::string  fileOutputName  =   "stdout";
   bool         fDebug          =   false   ;
   
   // ................................................................ get opt
   
   if (argc==1) 
   { 
        $loader( Info,noAction,noInputFiles,0,0,fileInputName,"argc=1"); 
   }
   
   int optNDX=1;
   do {
        std::string opt(argv[optNDX]);
        if (opt=="-i")
        {
            if((optNDX+1)<argc)
            { 
                fileInputName=std::string(argv[optNDX+1]); ++optNDX;  
            }
            else
            { 
                $loader( fatal,checkFileExists,noInputFiles,0,0,fileInputName,"-i ?");
            }
        }
        if (opt=="-o")
        {
            if((optNDX+1)<argc)
            { 
                fileOutputName=std::string(argv[optNDX+1]); ++optNDX; 
            }
            else
            { 
                $loader( fatal,checkFileExists,noInputFiles,0,0,fileInputName,"-o ?");
            }
        }
        if (opt=="-g")
        {
            fDebug=true; 
            ++optNDX;
        }
   } while(++optNDX<argc);

    if ( fileOutputName == "stdout" )
    {
        fileInputName="a.out";
        $loader( warning,checkFileExists,noInputFiles,0,0,fileInputName,"-o <default>");
    }

   // ................................................................ debug
   if ( !Error::kError )
   {
       if ( fDebug==true )
       {
           std::cout << "\n fi    " << fileInputName            << "." ;
           std::cout << "\n fo    " << fileOutputName           << "." ;
           std::cout << "\n debug " << (fDebug?"true":"false")  << "." ;
           std::cout << "\n" ;
       }
       
       // ................................................................ Lexer

        Lexer lex(fileInputName,fDebug) ;

        lex.scan();

        //if ( fDebug==true ) Token::print( fileInputName ) ;
    
/*
       lex.printFile();
       
       // ................................................................ parser
 
       if ( !Error::kError )
       {
           Parser par;
       }
*/
   }
   
   // ................................................................ The End 
 
   Error::printErrLog();
   
   Token::Delete();
   
   Error::Delete();
 
   std::cout << "\n";
   
   return 0 ;
}