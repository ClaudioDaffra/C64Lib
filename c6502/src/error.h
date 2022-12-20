
#ifndef cdError
#define cdError

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <cstddef>
#include <vector>

// ................................................... sender

typedef enum sender_e
{
    sender_loader   ,   // caricatore file
    sender_lexer    ,   // lexer
    sender_parser   ,   // parser
    sender_ast      ,   // ast
    sender_node     ,   // node 
    sender_asm      ,   // assembler 
    sender_vm       ,   // Virtual Machine 
    sender_scanner  ,   // analizzatore sematico 
    sender_cpp      ,   // preprocessore
} e_sender_t ;

typedef struct sender_s
{
    std::string      value;
} sender_t ;

#define $sender(x) sender[sender_##x].value

extern sender_t sender[]  ;

// ................................................... type

typedef enum type_e
{
    type_Info       ,   // informativa
    type_warning    ,   // avvertimento
    type_error      ,   // errore
    type_critical   ,   // errore critico
    type_fatal      ,   // errore fatale 
    type_internal       // interno al compilatore   
} e_type_t ;

typedef struct type_s
{
    std::string      value;  
} type_t ;

#define $type(x) type[type_##x].value

extern type_t type[]  ;
 
// ................................................... action

typedef enum action_e
{
    action_noErr            ,   // nessuno errore = 0
    action_noAction         ,   // nessuna azione
    action_checkFileExists  ,   // controllo esistenza file
    action_scanComment      ,   // mentre scannerizzo commento multilinea
    action_pushToken        ,   // mentre metto carattere nel tokenText    
    action_scanNumber       ,   // mentre sto scannerizzando numeri esa/decimali
    action_convertToNumber  ,   // mentre sto convertendo una stringa ad un numero
    action_parseExpr        ,   // mentro sto parsando espressione
    action_openFile         ,   // mentre sto aprendo/creando un file sorgente
    action_parse            ,   // mentre sto effettuando l'analisi sintattica
    action_malloc           ,   // mentre sto allocando memoria
    action_dealloc          ,   // mentre sto allocando memoria     
    action_debug            ,   // mentre debug ( node o altro ) 
    action_running          ,   // mentre siamo in esecuzione del codice 
    action_assembling       ,   // mentre sto assemblando codice macchina 
    action_scanning         ,   // mentre sto analizzando semanticamente
    action_tokenizing       ,   // mentre sto analissado col lexer   
            
} e_action_t ;

typedef struct action_s
{
    std::string      value;  
} action_t ;

#define $action(x) action[action_##x].value

extern action_t action[]  ;

// ................................................... errMessage

typedef enum errMessage_e
{
    errMessage_noErr                           ,   // nessun errore
    errMessage_fileNotFound                    ,   // file no trovato
    errMessage_noInputFiles                    ,   // nessun file in input    
    errMessage_eof                             ,   // raggiunta la fine del file
    errMessage_eoRem                           ,   // trovato commento multilinea di chiusura, iniziale
    errMessage_overflowTokenText               ,   // la lunghezza del token eccede quella del buffer    
    errMessage_expectedNumericLiteral        ,   // atteso numero esadecimale
    errMessage_invalid_argument                ,   // argometo non valido
    errMessage_out_of_range                    ,   // fuori range    
    errMessage_expectedExponent              ,   // hexadecimal floating constants require an exponent
    errMessage_expectedExponentDigit           ,   // exponent has no digit
    errMessage_outOfRangeNDX                 ,   // indice vettore fouri dai limiti
    errMessage_unexpectedSym                 ,   // simbolo inatteso
    errMessage_errUnknown                      ,   // errore sconosciuto
    errMessage_unexpectedToken                 ,   // token inatteso     
	errMessage_didYouMean                      ,   // intendevi forse ?
    errMessage_syntaxError                     ,   // errore di sintassi
    errMessage_outOfMemory                     ,   // mancanza di memoria !  
    errMessage_notImplemetedYet                ,   // non ancora implementato 
    errMessage_division_by_zero                ,   // 1 / 0 ;
    errMessage_duplicateSymbolName             ,   // identificare già presente nella tabella dei simboli
    errMessage_undeclaredIdentifier            ,   // identificatore non dichiarato
    errMessage_LValueRequired                  ,   // e' richiesto un valore sinistro
    errMessage_expectedPrimaryExprBefore       ,   // expected primary-expression before [token]
    errMessage_expectedPrimaryExprAfter        ,   // expected primary-expression before [token 
    errMessage_arrayBoundNotInteger            ,   // array bound is not an integer constant before ']' 
    errMessage_typeVoid                        ,   // nessun campo trovato nella struttura 
    errMessage_symbolNotDeclared               ,   // simbol was not declared in this scope 
    errMessage_invalidUseOf                    ,   // invalid use of (symbol)
    errMessage_incompleteUCN                   ,   // incomplete universal chracter name
    
} e_errMessage_t;

typedef struct errMessage_s
{
    std::string      value;  
} errMessage_t ;

// ........................................................  errMessage[]

#define $errMessage(x) errMessage[errMessage_##x].value

extern errMessage_t errMessage[]  ;

// ........................................................  err log Message

struct errLog_s
{
    public:
        e_sender_t          sender      ;
        e_type_t            type        ;
        e_action_t          action      ;
        e_errMessage_t      errMessage  ;
        uint32_t            rowTok      ;
        uint32_t            colTok      ;
        std::string         fileInput   ;
        std::string         extra       ;
} ;

typedef struct errLog_s errLog_t ;

class Error
{
    public:
    
    static uint32_t                 kError      ;
    static uint32_t                 kWarning    ;
    static std::vector<errLog_t*>   vErrLog     ;
    
    static size_t pushErrLog
    (
        e_sender_t          sender      ,
        e_type_t            type        ,
        e_action_t          action      ,
        e_errMessage_t      errMessage  ,
        uint32_t            rowTok      ,
        uint32_t            colTok      ,
        std::string         fileInput   ,
        std::string         extra        
    ) ;
    
    static int printErrLog  (void)  ;
    static int Delete       (void)  ;
    
} ;

// macro

// ...................................................................................... error

#define $pushErrLog( SENDER,TYPE,ACTION,ERRMESSAGE,ROW,COL,FILE,EXTRA )\
        Error::pushErrLog(\
            sender_##SENDER,\
            type_##TYPE,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            ROW,\
            COL,\
            FILE,\
            EXTRA\
        ) ;

// ...................................................................................... loader

#define $loader( TYPE,ACTION,ERRMESSAGE,ROW,COL,FILE,EXTRA )\
        Error::pushErrLog(\
            sender_loader,\
            type_##TYPE,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            ROW,\
            COL,\
            FILE,\
            EXTRA\
        ) ;

// ...................................................................................... lexer

#define $lexer( TYPE,ACTION,ERRMESSAGE,ROW,COL,FILE,EXTRA )\
        Error::pushErrLog(\
            sender_lexer,\
            type_##TYPE,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            ROW,\
            COL,\
            FILE,\
            EXTRA\
        ) ;

/*
#define $lexerWarning( ACTION,ERRMESSAGE )\
        pushErrLog(\
            sender_lexer,\
            type_warning,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            this->row_start,\
            this->col_start,\
            gcStrDup((char*)this->fileInputName),\
            NULL\
        ) ;

#define $lexerWarningExtra( ACTION,ERRMESSAGE,EXTRA )\
        pushErrLog(\
            sender_lexer,\
            type_warning,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            this->row_start,\
            this->col_start,\
            gcStrDup((char*)this->fileInputName),\
            gcStrDup((char*)EXTRA)\
        ) ;
                
#define $lexerError( ACTION,ERRMESSAGE )\
        pushErrLog(\
            sender_lexer,\
            type_error,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            this->row_start,\
            this->col_start,\
            gcStrDup((char*)this->fileInputName),\
            NULL\
        ) ;
        
#define $lexerInternal( ACTION,ERRMESSAGE,FILE,EXTRA )\
        pushErrLog(\
            sender_lexer,\
            type_internal,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            0,\
            0,\
            gcStrDup((char*)FILE),\
            gcStrDup(EXTRA)\
        ) ;

#define $lexerErrorExtra( ACTION,ERRMESSAGE,EXTRA )\
        pushErrLog(\
            sender_lexer,\
            type_error,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            this->row_start,\
            this->col_start,\
            gcStrDup((char*)this->fileInputName),\
            gcStrDup((char*)EXTRA)\
        ) ;

// ...................................................................................... parser

#define $parserInternal( ACTION,ERRMESSAGE,FILE,EXTRA )\
        pushErrLog(\
            sender_parser,\
            type_internal,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            0,\
            0,\
            gcStrDup((char*)FILE),\
            gcStrDup(EXTRA)\
        ) ;

#define $parserInternalExtra( ACTION,ERRMESSAGE,FILE,EXTRA )\
        pushErrLog(\
            sender_parser,\
            type_internal,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            this->lexer->row_start,\
            this->lexer->col_start,\
            gcStrDup((char*)FILE),\
            gcStrDup(EXTRA)\
        ) ;
        
#define $parserError( ACTION,ERRMESSAGE )\
        pushErrLog(\
            sender_parser,\
            type_error,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            this->lexer->row_start,\
            this->lexer->col_start,\
            gcStrDup((char*)this->lexer->fileInputName),\
            NULL\
        ) ;
        
#define $parserErrorExtra( ACTION,ERRMESSAGE,EXTRA )\
        pushErrLog(\
            sender_parser,\
            type_error,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            this->lexer->row_start,\
            this->lexer->col_start,\
            gcStrDup((char*)this->lexer->fileInputName),\
            gcStrDup(EXTRA)\
        ) ;
        
#define $syntaxError \
            pushErrLog(\
                sender_parser,\
                type_error,\
                action_parse,\
                errMessage_syntaxError,\
                this->lexer->row_start,\
                this->lexer->col_start,\
                gcStrDup((char*)this->lexer->fileInputName),\
                gcStrDup(this->lexer->token)\
           ) ;
 
#define $matchError( EXTRA )\
            pushErrLog(\
                sender_parser,\
                type_error,\
                action_parseExpr,\
                errMessage_unexpectedToken,\
                this->lexer->row_start,\
                this->lexer->col_start,\
                gcStrDup((char*)this->lexer->fileInputName),\
                gcStrDup(EXTRA)\
           ) ; 
               
                  
// ...................................................................................... ast

#define $astInternal( ACTION,ERRMESSAGE,FILE,EXTRA )\
        pushErrLog(\
            sender_ast,\
            type_internal,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            0,\
            0,\
            gcStrDup((char*)FILE),\
            gcStrDup(EXTRA)\
        ) ;
        
// ...................................................................................... node

#define $nodeInternal( ACTION,ERRMESSAGE,FILE,EXTRA )\
        pushErrLog(\
            sender_node,\
            type_internal,\
            action_##ACTION,\
            errMessage_##ERRMESSAGE,\
            0,\
            0,\
            gcStrDup((char*)FILE),\
            gcStrDup(EXTRA)\
        ) ;
*/


#endif
