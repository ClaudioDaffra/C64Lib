
#include "petscii.h"

std::map<std::string,unsigned char> c64ScreenCodesLowerCase =
{
    {   "@"     ,    0    } , // @    0x00 -> COMMERCIAL AT
    {   "a"     ,    1    } , // a    0x01 -> A
    {   "b"     ,    2    } , // b    0x02 -> B
    {   "c"     ,    3    } , // c    0x03 -> C
    {   "d"     ,    4    } , // d    0x04 -> D
    {   "e"     ,    5    } , // e    0x05 -> E
    {   "f"     ,    6    } , // f    0x06 -> F
    {   "g"     ,    7    } , // g    0x07 -> G
    {   "h"     ,    8    } , // h    0x08 -> H
    {   "i"     ,    9    } , // i    0x09 -> I

    {   "j"     ,   10    } , // j    0x0A -> J
    {   "k"     ,   11    } , // k    0x0B -> K
    {   "l"     ,   12    } , // l    0x0C -> L
    {   "m"     ,   13    } , // m    0x0D -> M
    {   "n"     ,   14    } , // n    0x0E -> N
    {   "o"     ,   15    } , // o    0x0F -> O
    {   "p"     ,   16    } , // p    0x10 -> P
    {   "q"     ,   17    } , // q    0x11 -> Q
    {   "r"     ,   18    } , // r    0x12 -> R
    {   "s"     ,   19    } , // s    0x13 -> S

    {   "t"     ,   20    } , // t    0x14 -> T
    {   "u"     ,   21    } , // u    0x15 -> U
    {   "v"     ,   22    } , // v    0x16 -> V
    {   "w"     ,   23    } , // w    0x17 -> W
    {   "x"     ,   24    } , // x    0x18 -> X
    {   "y"     ,   25    } , // y    0x19 -> Y
    {   "z"     ,   26    } , // z    0x1A -> Z
    {   "["     ,   27    } , // [    0x1B -> [
    {   "u00a3" ,   28    } , // £    0x1C -> £
    {   "]"     ,   29    } , // ]    0x1D -> ]

    {   "u2191" ,   30    } , // ↑    0x1E -> UPWARDS ARROW
    {   "u2190" ,   31    } , // ←    0x1F -> LEFTWARDS ARROW
    {   " "     ,   32    } , //      0x20 -> SPACE
    {   "!"     ,   33    } , // !    0x21 -> !
    {   "\""    ,   34    } , // "    0x22 -> "
    {   "#"     ,   35    } , // #    0x23 -> #
    {   "$"     ,   36    } , // $    0x24 -> $
    {   "%"     ,   37    } , // %    0x25 -> %
    {   "&"     ,   38    } , // &    0x26 -> &
    {   "'"     ,   39    } , //"    0x27 -> '
    {   "("     ,   40    } , // (    0x28 -> (

    {   ")"     ,   41    } , // )    0x29 -> )
    {   "*"     ,   42    } , // *    0x2A -> *
    {   "+"     ,   43    } , // +    0x2B -> +
    {   ","     ,   44    } , // ,    0x2C -> ,
    {   "-"     ,   45    } , // -    0x2D -> -
    {   "."     ,   46    } , // .    0x2E -> .
    {   "/"     ,   47    } , // /    0x2F -> /
    {   "0"     ,   48    } , // 0    0x30 -> 0
    {   "1"     ,   49    } , // 1    0x31 -> 1

    {   "2"     ,   50    } , // 2    0x32 -> 2
    {   "3"     ,   51    } , // 3    0x33 -> 3
    {   "4"     ,   52    } , // 4    0x34 -> 4
    {   "5"     ,   53    } , // 5    0x35 -> 5
    {   "6"     ,   54    } , // 6    0x36 -> 6
    {   "7"     ,   55    } , // 7    0x37 -> 7
    {   "8"     ,   56    } , // 8    0x38 -> 8
    {   "9"     ,   57    } , // 9    0x39 -> 9
    {   ":"     ,   58    } , // :    0x3A -> :
    {   ";"     ,   59    } , // ;    0x3B -> ;
    
    {   "<"     ,   60    } , // <    0x3C -> <
    {   "="     ,   61    } , // =    0x3D -> =
    {   ">"     ,   62    } , // >    0x3E -> >
    {   "?"     ,   63    } , // ?    0x3F -> ?
    {   "u2500" ,   64    } , // ─    0x40 -> box LIGHT HORIZONTAL
    {   "A"     ,   65    } , // A    0x41 -> LATIN CAPITAL LETTER A
    {   "B"     ,   66    } , // B    0x42 -> LATIN CAPITAL LETTER B
    {   "C"     ,   67    } , // C    0x43 -> LATIN CAPITAL LETTER C
    {   "D"     ,   68    } , // D    0x44 -> LATIN CAPITAL LETTER D
    {   "E"     ,   69    } , // E    0x45 -> LATIN CAPITAL LETTER E

    {   "F"     ,   70    } , // F    0x46 -> LATIN CAPITAL LETTER F
    {   "G"     ,   71    } , // G    0x47 -> LATIN CAPITAL LETTER G
    {   "H"     ,   72    } , // H    0x48 -> LATIN CAPITAL LETTER H
    {   "I"     ,   73    } , // I    0x49 -> LATIN CAPITAL LETTER I
    {   "J"     ,   74    } , // J    0x4A -> LATIN CAPITAL LETTER J
    {   "K"     ,   75    } , // K    0x4B -> LATIN CAPITAL LETTER K
    {   "L"     ,   76    } , // L    0x4C -> LATIN CAPITAL LETTER L
    {   "M"     ,   77    } , // M    0x4D -> LATIN CAPITAL LETTER M
    {   "N"     ,   78    } , // N    0x4E -> LATIN CAPITAL LETTER N
    {   "O"     ,   79    } , // O    0x4F -> LATIN CAPITAL LETTER O

    {   "P"     ,   80    } , // P    0x50 -> LATIN CAPITAL LETTER P
    {   "Q"     ,   81    } , // Q    0x51 -> LATIN CAPITAL LETTER Q
    {   "R"     ,   82    } , // R    0x52 -> LATIN CAPITAL LETTER R
    {   "S"     ,   83    } , // S    0x53 -> LATIN CAPITAL LETTER S
    {   "T"     ,   84    } , // T    0x54 -> LATIN CAPITAL LETTER T
    {   "U"     ,   85    } , // U    0x55 -> LATIN CAPITAL LETTER U
    {   "V"     ,   86    } , // V    0x56 -> LATIN CAPITAL LETTER V
    {   "W"     ,   87    } , // W    0x57 -> LATIN CAPITAL LETTER W
    {   "X"     ,   88    } , // X    0x58 -> LATIN CAPITAL LETTER X
    {   "Y"     ,   89    } , // Y    0x59 -> LATIN CAPITAL LETTER Y

    {   "Z"     ,   90    } , // Z    0x5A -> LATIN CAPITAL LETTER Z
    {   "u253c" ,   91    } , // ┼    0x5B -> box LIGHT VERTICAL AND HORIZONTAL
    {   "uf12e" ,   92    } , //     0x5C -> LEFT HALF BLOCK MEDIUM SHADE 
    {   "u2502" ,   93    } , // │    0x5D -> box LIGHT VERTICAL
    {   "u2592" ,   94    } , // ▒    0x5E -> MEDIUM SHADE
    {   "uf139" ,   95    } , //     0x5F -> MEDIUM SHADE SLASHED LEFT 
    {   "u00a0" ,   96    } , //      0x60 -> NO-BREAK SPACE
    {   "u258c" ,   97    } , // ▌    0x61 -> LEFT HALF BLOCK
    {   "u2584" ,   98    } , // ▄    0x62 -> LOWER HALF BLOCK
    {   "u2594" ,   99    } , // ▔    0x63 -> UPPER 1/8 BLOCK

    {   "u2581" ,  100    } , // ▁    0x64 -> LOWER 1/8 BLOCK
    {   "u258f" ,  101    } , // ▏    0x65 -> LEFT 1/8 BLOCK
    {   "u2592" ,  102    } , // ▒    0x66 -> MEDIUM SHADE
    {   "u2595" ,  103    } , // ▕    0x67 -> RIGHT 1/8 BLOCK
    {   "uf12f" ,  104    } , //     0x68 -> LOWER HALF BLOCK MEDIUM SHADE 
    {   "uf13a" ,  105    } , //     0x69 -> MEDIUM SHADE SLASHED RIGHT 
    {   "uf130" ,  106    } , //     0x6A -> RIGHT 1/4 BLOCK 
    {   "u251c" ,  107    } , // ├    0x6B -> box LIGHT VERTICAL AND RIGHT
    {   "u2597" ,  108    } , // ▗    0x6C -> QUADRANT LOWER RIGHT
    {   "u2514" ,  109    } , // └    0x6D -> box LIGHT UP AND RIGHT

    {   "u2510" ,  110    } , // ┐    0x6E -> box LIGHT DOWN AND LEFT
    {   "u2582" ,  111    } , // ▂    0x6F -> LOWER 1/4 BLOCK
    {   "u250c" ,  112    } , // ┌    0x70 -> box LIGHT DOWN AND RIGHT
    {   "u2534" ,  113    } , // ┴    0x71 -> box LIGHT UP AND HORIZONTAL
    {   "u252c" ,  114    } , // ┬    0x72 -> box LIGHT DOWN AND HORIZONTAL
    {   "u2524" ,  115    } , // ┤    0x73 -> box LIGHT VERTICAL AND LEFT
    {   "u258e" ,  116    } , // ▎    0x74 -> LEFT 1/4 BLOCK
    {   "u258d" ,  117    } , // ▍    0x75 -> LEFT 3/8 BLOCK
    {   "uf131" ,  118    } , //     0x76 -> RIGHT 3/8 BLOCK 
    {   "uf132" ,  119    } , //     0x77 -> UPPER 1/4 BLOCK 

    {   "uf133" ,  120    } , //     0x78 -> UPPER 3/8 BLOCK 
    {   "u2583" ,  121    } , // ▃    0x79 -> LOWER 3/8 BLOCK
    {   "u2713" ,  122    } , // ✓    0x7A -> CHECK MARK
    {   "u2596" ,  123    } , // ▖    0x7B -> QUADRANT LOWER LEFT
    {   "u259d" ,  124    } , // ▝    0x7C -> QUADRANT UPPER RIGHT
    {   "u2518" ,  125    } , // ┘    0x7D -> box LIGHT UP AND LEFT
    {   "u2598" ,  126    } , // ▘    0x7E -> QUADRANT UPPER LEFT
    {   "u259a" ,  127    } , // ▚    0x7F -> QUADRANT UPPER LEFT AND LOWER RIGHT

} ;

std::map<std::string,unsigned char> c64ScreenNamesLowerCase =
{
    {   "@"         ,    0    } , // @    0x00 -> commercial at
    {   "a"         ,    1    } , // a    0x01 -> a
    {   "b"         ,    2    } , // b    0x02 -> b
    {   "c"         ,    3    } , // c    0x03 -> c
    {   "d"         ,    4    } , // d    0x04 -> d
    {   "e"         ,    5    } , // e    0x05 -> e
    {   "f"         ,    6    } , // f    0x06 -> f
    {   "g"         ,    7    } , // g    0x07 -> g
    {   "h"         ,    8    } , // h    0x08 -> h
    {   "h"         ,    9    } , // i    0x09 -> h

    {   "j"         ,   10    } , // j    0x0a -> j
    {   "k"         ,   11    } , // k    0x0b -> k
    {   "l"         ,   12    } , // l    0x0c -> l
    {   "m"         ,   13    } , // m    0x0d -> m
    {   "n"         ,   14    } , // n    0x0e -> n
    {   "o"         ,   15    } , // o    0x0f -> o
    {   "p"         ,   16    } , // p    0x10 -> p
    {   "q"         ,   17    } , // q    0x11 -> q
    {   "r"         ,   18    } , // r    0x12 -> r
    {   "s"         ,   19    } , // s    0x13 -> s

    {   "t"         ,   20    } , // t    0x14 -> t
    {   "u"         ,   21    } , // u    0x15 -> u
    {   "v"         ,   22    } , // v    0x16 -> v
    {   "w"         ,   23    } , // w    0x17 -> w
    {   "x"         ,   24    } , // x    0x18 -> x
    {   "y"         ,   25    } , // y    0x19 -> y
    {   "z"         ,   26    } , // z    0x1a -> z
    {   "["         ,   27    } , // [    0x1b -> [
    {   "£"         ,   28    } , // £    0x1c -> £
    {   "]"         ,   29    } , // ]    0x1d -> ]
    
    {   "upwards arrow"             ,   30    } , // ↑    0x1e -> upwards arrow
    {   "leftwards arrow"           ,   31    } , // ←    0x1f -> leftwards arrow
    {   "leftwards arrow"           ,   32    } , //      0x20 -> space
    {   "!"                         ,   33    } , // !    0x21 -> !
    {   "\""                        ,   34    } , // "    0x22 -> "
    {   "#"                         ,   35    } , // #    0x23 -> #
    {   "$"                         ,   36    } , // $    0x24 -> $
    {   "%"                         ,   37    } , // %    0x25 -> %
    {   "&"                         ,   38    } , // &    0x26 -> &
    {   "'"                         ,   39    } , //"    0x27 -> '

    {   "("                         ,   40    } , // (    0x28 -> (
    {   ")"                         ,   41    } , // )    0x29 -> )
    {   "*"                         ,   42    } , // *    0x2a -> *
    {   "+"                         ,   43    } , // +    0x2b -> +
    {   ","                         ,   44    } , // ,    0x2c -> ,
    {   "-"                         ,   45    } , // -    0x2d -> -
    {   "."                         ,   46    } , // .    0x2e -> .
    {   "/"                         ,   47    } , // /    0x2f -> /
    {   "0"                         ,   48    } , // 0    0x30 -> 0
    {   "1"                         ,   49    } , // 1    0x31 -> 1

    {   "2"                         ,   50    } , // 2    0x32 -> 2
    {   "3"                         ,   51    } , // 3    0x33 -> 3
    {   "4"                         ,   52    } , // 4    0x34 -> 4
    {   "5"                         ,   53    } , // 5    0x35 -> 5
    {   "6"                         ,   54    } , // 6    0x36 -> 6
    {   "7"                         ,   55    } , // 7    0x37 -> 7
    {   "8"                         ,   56    } , // 8    0x38 -> 8
    {   "9"                         ,   57    } , // 9    0x39 -> 9
    {   ":"                         ,   58    } , // :    0x3a -> :
    {   ";"                         ,   59    } , // ;    0x3b -> ;

    {   "<"                         ,   60    } , // <    0x3c -> <
    {   "="                         ,   61    } , // =    0x3d -> =
    {   ">"                         ,   62    } , // >    0x3e -> >
    {   "?"                         ,   63    } , // ?    0x3f -> ?
    {   "box light horizontal"      ,   64    } , // ─    0x40 -> box light horizontal
   
    {   "A"       ,   65    } , // a    0x41 -> latin capital letter a
    {   "B"       ,   66    } , // b    0x42 -> latin capital letter b
    {   "C"       ,   67    } , // c    0x43 -> latin capital letter c
    {   "C"       ,   68    } , // d    0x44 -> latin capital letter d
    {   "E"       ,   69    } , // e    0x45 -> latin capital letter e

    {   "F"       ,   70    } , // f    0x46 -> latin capital letter f
    {   "G"       ,   71    } , // g    0x47 -> latin capital letter g
    {   "H"       ,   72    } , // h    0x48 -> latin capital letter h
    {   "I"       ,   73    } , // i    0x49 -> latin capital letter i
    {   "J"       ,   74    } , // j    0x4a -> latin capital letter j
    {   "K"       ,   75    } , // k    0x4b -> latin capital letter k
    {   "L"       ,   76    } , // l    0x4c -> latin capital letter l
    {   "M"       ,   77    } , // m    0x4d -> latin capital letter m
    {   "N"       ,   78    } , // n    0x4e -> latin capital letter n
    {   "O"       ,   79    } , // o    0x4f -> latin capital letter o

    {   "P"       ,   80    } , // p    0x50 -> latin capital letter p
    {   "Q"       ,   81    } , // q    0x51 -> latin capital letter q
    {   "R"       ,   82    } , // r    0x52 -> latin capital letter r
    {   "S"       ,   83    } , // s    0x53 -> latin capital letter s
    {   "T"       ,   84    } , // t    0x54 -> latin capital letter t
    {   "U"       ,   85    } , // u    0x55 -> latin capital letter u
    {   "V"       ,   86    } , // v    0x56 -> latin capital letter v
    {   "W"       ,   87    } , // w    0x57 -> latin capital letter w
    {   "X"       ,   88    } , // x    0x58 -> latin capital letter x
    {   "Y"       ,   89    } , // y    0x59 -> latin capital letter y

    {   "Z"       ,   90    } , // z    0x5a -> latin capital letter z
    
    {   "box light vertical and horizontal"         ,   91    } , // ┼    0x5b -> box light vertical and horizontal
    {   "left half block medium shade"              ,   92    } , //     0x5c -> left half block medium shade 
    {   "box light vertical"                        ,   93    } , // │    0x5d -> box light vertical
    {   "medium shade"                              ,   94    } , // ▒    0x5e -> medium shade
    {   "medium shade slashed left"                 ,   95    } , //     0x5f -> medium shade slashed left 
    {   "no-break space"                            ,   96    } , //      0x60 -> no-break space
    {   "left half block"                           ,   97    } , // ▌    0x61 -> left half block
    {   "lower half block"                          ,   98    } , // ▄    0x62 -> lower half block
    {   "upper 1/8 block"                           ,   99    } , // ▔    0x63 -> upper 1/8 block

    {   "lower 1/8 block"                           ,  100    } , // ▁    0x64 -> lower 1/8 block
    {   "left 1/8 block"                            ,  101    } , // ▏    0x65 -> left 1/8 block
    {   "medium shade"                              ,  102    } , // ▒    0x66 -> medium shade
    {   "right 1/8 block"                           ,  103    } , // ▕    0x67 -> right 1/8 block
    {   "lower half block medium shade"             ,  104    } , //     0x68 -> lower half block medium shade 
    {   "medium shade slashed right"                ,  105    } , //     0x69 -> medium shade slashed right 
    {   "right 1/4 block "                          ,  106    } , //     0x6a -> right 1/4 block 
    {   "box light vertical and right"              ,  107    } , // ├    0x6b -> box light vertical and right
    {   "quadrant lower right"                      ,  108    } , // ▗    0x6c -> quadrant lower right
    {   "box light up and right"                    ,  109    } , // └    0x6d -> box light up and right

    {   "box light down and left"                   ,  110    } , // ┐    0x6e -> box light down and left
    {   "lower 1/4 block"                           ,  111    } , // ▂    0x6f -> lower 1/4 block
    {   "box light down and right"                  ,  112    } , // ┌    0x70 -> box light down and right
    {   "box light up and horizontal"               ,  113    } , // ┴    0x71 -> box light up and horizontal
    {   "box light down and horizontal"             ,  114    } , // ┬    0x72 -> box light down and horizontal
    {   "box light vertical and left"               ,  115    } , // ┤    0x73 -> box light vertical and left
    {   "left 1/4 block"                            ,  116    } , // ▎    0x74 -> left 1/4 block
    {   "left 3/8 block"                            ,  117    } , // ▍    0x75 -> left 3/8 block
    {   "right 3/8 block"                           ,  118    } , //     0x76 -> right 3/8 block 
    {   "upper 1/4 block"                           ,  119    } , //     0x77 -> upper 1/4 block 

    {   "upper 3/8 block"                           ,  120    } , //     0x78 -> upper 3/8 block 
    {   "lower 3/8 block"                           ,  121    } , // ▃    0x79 -> lower 3/8 block
    {   "check mark"                                ,  122    } , // ✓    0x7a -> check mark
    {   "quadrant lower left"                       ,  123    } , // ▖    0x7b -> quadrant lower left
    {   "quadrant upper right"                      ,  124    } , // ▝    0x7c -> quadrant upper right
    {   "box light up and left"                     ,  125    } , // ┘    0x7d -> box light up and left
    {   "quadrant upper left"                       ,  126    } , // ▘    0x7e -> quadrant upper left
    {   "quadrant upper left and lower right"       ,  127    } , // ▚    0x7f -> quadrant upper left and lower right

} ;

std::map<std::string,unsigned char> c64ScreenCodesUpperCase =
{
       { "@"     ,    0} , //    @    0x00 -> COMMERCIAL AT
       { "A"     ,    1} , //    A    0x01 -> LATIN CAPITAL LETTER A
       { "B"     ,    2} , //    B    0x02 -> LATIN CAPITAL LETTER B
       { "C"     ,    3} , //    C    0x03 -> LATIN CAPITAL LETTER C
       { "D"     ,    4} , //    D    0x04 -> LATIN CAPITAL LETTER D
       { "E"     ,    5} , //    E    0x05 -> LATIN CAPITAL LETTER E
       { "F"     ,    6} , //    F    0x06 -> LATIN CAPITAL LETTER F
       { "G"     ,    7} , //    G    0x07 -> LATIN CAPITAL LETTER G
       { "H"     ,    8} , //    H    0x08 -> LATIN CAPITAL LETTER H
       { "I"     ,    9} , //    I    0x09 -> LATIN CAPITAL LETTER I

       { "J"     ,   10} , //    J    0x0A -> LATIN CAPITAL LETTER J
       { "K"     ,   11} , //    K    0x0B -> LATIN CAPITAL LETTER K
       { "L"     ,   12} , //    L    0x0C -> LATIN CAPITAL LETTER L
       { "M"     ,   13} , //    M    0x0D -> LATIN CAPITAL LETTER M
       { "N"     ,   14} , //    N    0x0E -> LATIN CAPITAL LETTER N
       { "O"     ,   15} , //    O    0x0F -> LATIN CAPITAL LETTER O
       { "P"     ,   16} , //    P    0x10 -> LATIN CAPITAL LETTER P
       { "Q"     ,   17} , //    Q    0x11 -> LATIN CAPITAL LETTER Q
       { "R"     ,   18} , //    R    0x12 -> LATIN CAPITAL LETTER R
       { "S"     ,   19} , //    S    0x13 -> LATIN CAPITAL LETTER S
       { "T"     ,   20} , //    T    0x14 -> LATIN CAPITAL LETTER T

       { "U"     ,   21} , //    U    0x15 -> LATIN CAPITAL LETTER U
       { "V"     ,   22} , //    V    0x16 -> LATIN CAPITAL LETTER V
       { "W"     ,   23} , //    W    0x17 -> LATIN CAPITAL LETTER W
       { "X"     ,   24} , //    X    0x18 -> LATIN CAPITAL LETTER X
       { "Y"     ,   25} , //    Y    0x19 -> LATIN CAPITAL LETTER Y
       { "Z"     ,   26} , //    Z    0x1A -> LATIN CAPITAL LETTER Z
       { "["     ,   27} , //    [    0x1B -> [
       { "u00a3" ,   28} , //    £    0x1C -> £
       { "]"     ,   29} , //    ]    0x1D -> ]
       { "u2191" ,   30} , //    ↑    0x1E -> UPWARDS ARROW

       { "u2190" ,   31} , //    ←    0x1F -> LEFTWARDS ARROW
       { " "     ,   32} , //         0x20 -> SPACE
       { "!"     ,   33} , //    !    0x21 -> !
       { "\""    ,   34} , //    "    0x22 -> "
       { "#"     ,   35} , //    #    0x23 -> #
       { "$"     ,   36} , //    $    0x24 -> $
       { "%"     ,   37} , //    %    0x25 -> %
       { "&"     ,   38} , //    &    0x26 -> &
       { "'"     ,   39} , //   "    0x27 -> '

       { "("     ,   40} , //    (    0x28 -> (
       { ")"     ,   41} , //    )    0x29 -> )
       { "*"     ,   42} , //    *    0x2A -> *
       { "+"     ,   43} , //    +    0x2B -> +
       { ","     ,   44} , //    ,    0x2C -> ,
       { "-"     ,   45} , //    -    0x2D -> -
       { "."     ,   46} , //    .    0x2E -> .
       { "/"     ,   47} , //    /    0x2F -> /
       { "0"     ,   48} , //    0    0x30 -> 0
       { "1"     ,   49} , //    1    0x31 -> 1

       { "2"     ,   50} , //    2    0x32 -> 2
       { "3"     ,   51} , //    3    0x33 -> 3
       { "4"     ,   52} , //    4    0x34 -> 4
       { "5"     ,   53} , //    5    0x35 -> 5
       { "6"     ,   54} , //    6    0x36 -> 6
       { "7"     ,   55} , //    7    0x37 -> 7
       { "8"     ,   56} , //    8    0x38 -> 8
       { "9"     ,   57} , //    9    0x39 -> 9
       { ":"     ,   58} , //    :    0x3A -> :
       { ";"     ,   59} , //    ;    0x3B -> ;

       { "<"     ,   60} , //    <    0x3C -> <
       { "="     ,   61} , //    =    0x3D -> =
       { ">"     ,   62} , //    >    0x3E -> >
       { "?"     ,   63} , //    ?    0x3F -> ?
       { "u2500" ,   64} , //    ─    0x40 -> box LIGHT HORIZONTAL
       { "u2660" ,   65} , //    ♠    0x41 -> BLACK SPADE SUIT
       { "uf13c" ,   66} , //    │    0x42 -> box LIGHT VERTICAL 1/8 LEFT 
       { "uf13b" ,   67} , //    ─    0x43 -> box LIGHT HORIZONTAL 1/8 UP 
       { "uf122" ,   68} , //        0x44 -> box LIGHT HORIZONTAL 2/8 UP 
       { "uf123" ,   69} , //        0x45 -> box LIGHT HORIZONTAL 3/8 UP 

       { "uf124" ,   70} , //        0x46 -> box LIGHT HORIZONTAL 1/8 DOWN 
       { "uf126" ,   71} , //        0x47 -> box LIGHT VERTICAL 2/8 LEFT 
       { "uf128" ,   72} , //        0x48 -> box LIGHT VERTICAL 1/8 RIGHT 
       { "u256e" ,   73} , //    ╮    0x49 -> box LIGHT ARC DOWN AND LEFT
       { "u2570" ,   74} , //    ╰    0x4A -> box LIGHT ARC UP AND RIGHT
       { "u256f" ,   75} , //    ╯    0x4B -> box LIGHT ARC UP AND LEFT
       { "uf12a" ,   76} , //        0x4C -> 1/8 BLOCK UP AND RIGHT 
       { "u2572" ,   77} , //    ╲    0x4D -> box LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
       { "u2571" ,   78} , //    ╱    0x4E -> box LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
       { "uf12b" ,   79} , //        0x4F -> 1/8 BLOCK DOWN AND RIGHT 

       { "uf12c" ,   80} , //        0x50 -> 1/8 BLOCK DOWN AND LEFT 
       { "u25cf" ,   81} , //    ●    0x51 -> BLACK CIRCLE
       { "uf125" ,   82} , //        0x52 -> box LIGHT HORIZONTAL 2/8 DOWN 
       { "u2665" ,   83} , //    ♥    0x53 -> BLACK HEART SUIT
       { "uf127" ,   84} , //        0x54 -> box LIGHT VERTICAL 3/8 LEFT 
       { "u256d" ,   85} , //    ╭    0x55 -> box LIGHT ARC DOWN AND RIGHT
       { "u2573" ,   86} , //    ╳    0x56 -> box LIGHT DIAGONAL CROSS
       { "u25cb" ,   87} , //    ○    0x57 -> WHITE CIRCLE
       { "u2663" ,   88} , //    ♣    0x58 -> BLACK CLUB SUIT
       { "uf129" ,   89} , //        0x59 -> box LIGHT VERTICAL 2/8 RIGHT 

       { "u2666" ,   90} , //    ♦    0x5A -> BLACK DIAMOND SUIT
       { "u253c" ,   91} , //    ┼    0x5B -> box LIGHT VERTICAL AND HORIZONTAL
       { "uf12e" ,   92} , //        0x5C -> LEFT HALF BLOCK MEDIUM SHADE 
       { "u2502" ,   93} , //    │    0x5D -> box LIGHT VERTICAL
       { "u03c0" ,   94} , //    π    0x5E -> pi
       { "u25e5" ,   95} , //    ◥    0x5F -> BLACK UPPER RIGHT TRIANGLE
       { "u00a0" ,   96} , //         0x60 -> NO-BREAK SPACE
       { "u258c" ,   97} , //    ▌    0x61 -> LEFT HALF BLOCK
       { "u2584" ,   98} , //    ▄    0x62 -> LOWER HALF BLOCK
       { "u2594" ,   99} , //    ▔    0x63 -> UPPER 1/8 BLOCK

       { "u2581" ,  100} , //    ▁    0x64 -> LOWER 1/8 BLOCK
       { "u258f" ,  101} , //    ▏    0x65 -> LEFT 1/8 BLOCK
       { "u2592" ,  102} , //    ▒    0x66 -> MEDIUM SHADE
       { "u2595" ,  103} , //    ▕    0x67 -> RIGHT 1/8 BLOCK
       { "uf12f" ,  104} , //        0x68 -> LOWER HALF BLOCK MEDIUM SHADE 
       { "u25e4" ,  105} , //    ◤    0x69 -> BLACK UPPER LEFT TRIANGLE
       { "uf130" ,  106} , //        0x6A -> RIGHT 1/4 BLOCK 
       { "u251c" ,  107} , //    ├    0x6B -> box LIGHT VERTICAL AND RIGHT
       { "u2597" ,  108} , //    ▗    0x6C -> QUADRANT LOWER RIGHT
       { "u2514" ,  109} , //    └    0x6D -> box LIGHT UP AND RIGHT

       { "u2510" ,  110} , //    ┐    0x6E -> box LIGHT DOWN AND LEFT
       { "u2582" ,  111} , //    ▂    0x6F -> LOWER 1/4 BLOCK
       { "u250c" ,  112} , //    ┌    0x70 -> box LIGHT DOWN AND RIGHT
       { "u2534" ,  113} , //    ┴    0x71 -> box LIGHT UP AND HORIZONTAL
       { "u252c" ,  114} , //    ┬    0x72 -> box LIGHT DOWN AND HORIZONTAL
       { "u2524" ,  115} , //    ┤    0x73 -> box LIGHT VERTICAL AND LEFT
       { "u258e" ,  116} , //    ▎    0x74 -> LEFT 1/4 BLOCK
       { "u258d" ,  117} , //    ▍    0x75 -> LEFT 3/8 BLOCK
       { "uf131" ,  118} , //        0x76 -> RIGHT 3/8 BLOCK 
       { "uf132" ,  119} , //        0x77 -> UPPER 1/4 BLOCK 

       { "uf133" ,  120} , //        0x78 -> UPPER 3/8 BLOCK 
       { "u2583" ,  121} , //    ▃    0x79 -> LOWER 3/8 BLOCK
       { "uf12d" ,  122} , //        0x7A -> 1/8 BLOCK UP AND LEFT 
       { "u2596" ,  123} , //    ▖    0x7B -> QUADRANT LOWER LEFT
       { "u259d" ,  124} , //    ▝    0x7C -> QUADRANT UPPER RIGHT
       { "u2518" ,  125} , //    ┘    0x7D -> box LIGHT UP AND LEFT
       { "u2598" ,  126} , //    ▘    0x7E -> QUADRANT UPPER LEFT
       { "u259a" ,  127} , //    ▚    0x7F -> QUADRANT UPPER LEFT AND LOWER RIGHT

} ;

std::map<std::string,unsigned char> c64ScreenNamesUpperCase =
{
       { "@"     ,    0} , //    @    0x00 -> commercial at
       { "A"     ,    1} , //    a    0x01 -> latin capital letter a
       { "B"     ,    2} , //    b    0x02 -> latin capital letter b
       { "C"     ,    3} , //    c    0x03 -> latin capital letter c
       { "D"     ,    4} , //    d    0x04 -> latin capital letter d
       { "E"     ,    5} , //    e    0x05 -> latin capital letter e
       { "F"     ,    6} , //    f    0x06 -> latin capital letter f
       { "G"     ,    7} , //    g    0x07 -> latin capital letter g
       { "H"     ,    8} , //    h    0x08 -> latin capital letter h
       { "I"     ,    9} , //    i    0x09 -> latin capital letter i

       { "J"     ,   10} , //    j    0x0a -> latin capital letter j
       { "K"     ,   11} , //    k    0x0b -> latin capital letter k
       { "L"     ,   12} , //    l    0x0c -> latin capital letter l
       { "M"     ,   13} , //    m    0x0d -> latin capital letter m
       { "N"     ,   14} , //    n    0x0e -> latin capital letter n
       { "O"     ,   15} , //    o    0x0f -> latin capital letter o
       { "P"     ,   16} , //    p    0x10 -> latin capital letter p
       { "Q"     ,   17} , //    q    0x11 -> latin capital letter q
       { "R"     ,   18} , //    r    0x12 -> latin capital letter r
       { "S"     ,   19} , //    s    0x13 -> latin capital letter s

       { "T"     ,   20} , //    t    0x14 -> latin capital letter t
       { "U"     ,   21} , //    u    0x15 -> latin capital letter u
       { "V"     ,   22} , //    v    0x16 -> latin capital letter v
       { "W"     ,   23} , //    w    0x17 -> latin capital letter w
       { "X"     ,   24} , //    x    0x18 -> latin capital letter x
       { "U"     ,   25} , //    y    0x19 -> latin capital letter y
       { "Z"     ,   26} , //    z    0x1a -> latin capital letter z
       { "["     ,   27} , //    [    0x1b -> [
       { "£"     ,   28} , //    £    0x1c -> £
       { "]"     ,   29} , //    ]    0x1d -> ]
       
       { "upwards arrow"                ,   30} , //    ↑    0x1e -> upwards arrow

       { "leftwards arrow"              ,   31} , //    ←    0x1f -> leftwards arrow
       { " "                            ,   32} , //         0x20 -> space
       { "!"                ,   33} , //    !    0x21 -> !
       { "\""               ,   34} , //    "    0x22 -> "
       { "#"                ,   35} , //    #    0x23 -> #
       { "$"                ,   36} , //    $    0x24 -> $
       { "%"                ,   37} , //    %    0x25 -> %
       { "&"                ,   38} , //    &    0x26 -> &
       { "'"                ,   39} , //   "    0x27 -> '

       { "("                ,   40} , //    (    0x28 -> (
       { ")"                ,   41} , //    )    0x29 -> )
       { "*"                ,   42} , //    *    0x2a -> *
       { "+"                ,   43} , //    +    0x2b -> +
       { ","                ,   44} , //    ,    0x2c -> ,
       { "-"                ,   45} , //    -    0x2d -> -
       { "."                ,   46} , //    .    0x2e -> .
       { "/"                ,   47} , //    /    0x2f -> /
       { "0"                ,   48} , //    0    0x30 -> 0
       { "1"                ,   49} , //    1    0x31 -> 1

       { "2"                ,   50} , //    2    0x32 -> 2
       { "3"                ,   51} , //    3    0x33 -> 3
       { "4"                ,   52} , //    4    0x34 -> 4
       { "5"                ,   53} , //    5    0x35 -> 5
       { "6"                ,   54} , //    6    0x36 -> 6
       { "7"                ,   55} , //    7    0x37 -> 7
       { "8"                ,   56} , //    8    0x38 -> 8
       { "9"                ,   57} , //    9    0x39 -> 9
       { ":"                ,   58} , //    :    0x3a -> :
       { ";"                ,   59} , //    ;    0x3b -> ;

       { "<"                ,   60} , //    <    0x3c -> <
       { "="                ,   61} , //    =    0x3d -> =
       { ">"                ,   62} , //    >    0x3e -> >
       { "?"                ,   63} , //    ?    0x3f -> ?
      
       { "box light horizontal"                                 ,   64} , //    ─    0x40 -> box light horizontal
       { "black spade suit"                                     ,   65} , //    ♠    0x41 -> black spade suit
       { "box light vertical 1/8 left"                          ,   66} , //    │    0x42 -> box light vertical 1/8 left 
       { "box light horizontal 1/8 up"                          ,   67} , //    ─    0x43 -> box light horizontal 1/8 up 
       { "box light horizontal 2/8 up"                          ,   68} , //        0x44 -> box light horizontal 2/8 up 
       { "box light horizontal 3/8 up"                          ,   69} , //        0x45 -> box light horizontal 3/8 up 

       { "box light horizontal 1/8 down"                        ,   70} , //        0x46 -> box light horizontal 1/8 down 
       { "box light vertical 2/8 left"                          ,   71} , //        0x47 -> box light vertical 2/8 left 
       { "box light vertical 1/8 right"                         ,   72} , //        0x48 -> box light vertical 1/8 right 
       { "box light arc down and left"                          ,   73} , //    ╮    0x49 -> box light arc down and left
       { "box light arc up and right"                           ,   74} , //    ╰    0x4a -> box light arc up and right
       { "box light arc up and left"                            ,   75} , //    ╯    0x4b -> box light arc up and left
       { "1/8 block up and right"                               ,   76} , //        0x4c -> 1/8 block up and right 
       { "box light diagonal upper left to lower right"         ,   77} , //    ╲    0x4d -> box light diagonal upper left to lower right
       { "box light diagonal upper right to lower left"         ,   78} , //    ╱    0x4e -> box light diagonal upper right to lower left
       { "1/8 block down and right"                             ,   79} , //        0x4f -> 1/8 block down and right 

       { "1/8 block down and left"                              ,   80} , //        0x50 -> 1/8 block down and left 
       { "black circle"                                         ,   81} , //    ●    0x51 -> black circle
       { "box light horizontal 2/8 down"                        ,   82} , //        0x52 -> box light horizontal 2/8 down 
       { "black heart suit"                                     ,   83} , //    ♥    0x53 -> black heart suit
       { "box light vertical 3/8 left"                          ,   84} , //        0x54 -> box light vertical 3/8 left 
       { "box light arc down and right"                         ,   85} , //    ╭    0x55 -> box light arc down and right
       { "box light diagonal cross"                             ,   86} , //    ╳    0x56 -> box light diagonal cross
       
       { "white circle"                             ,   87} , //    ○    0x57 -> white circle
       { "black club suit"                          ,   88} , //    ♣    0x58 -> black club suit
       { "box light vertical 2/8 right"             ,   89} , //        0x59 -> box light vertical 2/8 right 

       { "black diamond suit"                       ,   90} , //    ♦    0x5a -> black diamond suit
       { "box light vertical and horizontal"        ,   91} , //    ┼    0x5b -> box light vertical and horizontal
       { "left half block medium shade"             ,   92} , //        0x5c -> left half block medium shade 
       { "box light vertical"                       ,   93} , //    │    0x5d -> box light vertical
       { "pi"                                       ,   94} , //    π    0x5e -> pi
       { "black upper right triangle"                        ,   95} , //    ◥    0x5f -> black upper right triangle
       { "no-break space"                                    ,   96} , //         0x60 -> no-break space
       { "left half block"                                   ,   97} , //    ▌    0x61 -> left half block
       { "lower half block"                                  ,   98} , //    ▄    0x62 -> lower half block
       { "upper 1/8 block"                                   ,   99} , //    ▔    0x63 -> upper 1/8 block

       { "lower 1/8 block"                                   ,  100} , //    ▁    0x64 -> lower 1/8 block
       { "left 1/8 block"                                    ,  101} , //    ▏    0x65 -> left 1/8 block
       { "medium shade"                                      ,  102} , //    ▒    0x66 -> medium shade
       { "right 1/8 block"                                   ,  103} , //    ▕    0x67 -> right 1/8 block
       { "lower half block medium shade"                     ,  104} , //        0x68 -> lower half block medium shade 
       { "black upper left triangle"                         ,  105} , //    ◤    0x69 -> black upper left triangle
       { "right 1/4 block"                                   ,  106} , //        0x6a -> right 1/4 block 
       { "box light vertical and right"                 ,  107} , //    ├    0x6b -> box light vertical and right
       { "quadrant lower right"                         ,  108} , //    ▗    0x6c -> quadrant lower right
       { "box light up and right"                       ,  109} , //    └    0x6d -> box light up and right

       { "box light down and left"                      ,  110} , //    ┐    0x6e -> box light down and left
       { "lower 1/4 block"                              ,  111} , //    ▂    0x6f -> lower 1/4 block
       { "box light down and right"                     ,  112} , //    ┌    0x70 -> box light down and right
       { "box light up and horizontal"                  ,  113} , //    ┴    0x71 -> box light up and horizontal
       { "box light down and horizontal"                ,  114} , //    ┬    0x72 -> box light down and horizontal
       { "box light vertical and left"                  ,  115} , //    ┤    0x73 -> box light vertical and left
       { "left 1/4 block"                               ,  116} , //    ▎    0x74 -> left 1/4 block
       { "left 3/8 block"                               ,  117} , //    ▍    0x75 -> left 3/8 block
       { "right 3/8 block"                              ,  118} , //        0x76 -> right 3/8 block 
       { "upper 1/4 block"                              ,  119} , //        0x77 -> upper 1/4 block 

       { "upper 3/8 block"                              ,  120} , //        0x78 -> upper 3/8 block 
       { "lower 3/8 block"                              ,  121} , //    ▃    0x79 -> lower 3/8 block
       { "1/8 block up and left"                        ,  122} , //        0x7a -> 1/8 block up and left 
       { "quadrant lower left"                          ,  123} , //    ▖    0x7b -> quadrant lower left
       { "quadrant upper right"                         ,  124} , //    ▝    0x7c -> quadrant upper right
       { "box light up and left"                        ,  125} , //    ┘    0x7d -> box light up and left
       { "quadrant upper left"                          ,  126} , //    ▘    0x7e -> quadrant upper left
       { "quadrant upper left and lower right"          ,  127} , //    ▚    0x7f -> quadrant upper left and lower right

} ;

std::map<std::string,unsigned char> c64PetsciiCodesLowerCase =
{
        { "u0000"       ,    0 } , //         0x00 -> u0000
        { "UNDEFINED"   ,    1 } , //         0x01 -> UNDEFINED
        { "UNDEFINED"   ,    2 } , //         0x02 -> UNDEFINED
        { "UNDEFINED"   ,    3 } , //         0x03 -> UNDEFINED
        { "UNDEFINED"   ,    4 } , //         0x04 -> UNDEFINED
        { "uf100"       ,    5 } , //         0x05 -> white 
        { "UNDEFINED"   ,    6 } , //         0x06 -> UNDEFINED
        { "UNDEFINED"   ,    7 } , //         0x07 -> UNDEFINED
        { "uf118"       ,    8 } , //         0x08 -> DISABLE CHARACTER SET SWITCHING 
        { "uf119"       ,    9 } , //         0x09 -> ENABLE CHARACTER SET SWITCHING 

        { "UNDEFINED"   ,   10 } , //         0x0A -> UNDEFINED
        { "UNDEFINED"   ,   11 } , //         0x0B -> UNDEFINED
        { "UNDEFINED"   ,   12 } , //         0x0C -> UNDEFINED
        { "\r"          ,   13 } , //         0x0D -> CARRIAGE RETURN
        { "u000e"       ,   14 } , //         0x0E -> SHIFT OUT
        { "UNDEFINED"   ,   15 } , //         0x0F -> UNDEFINED
        { "UNDEFINED"   ,   16 } , //         0x10 -> UNDEFINED
        { "uf11c"       ,   17 } , //         0x11 -> CURSOR DOWN 
        { "uf11a"       ,   18 } , //         0x12 -> reverse ON 
        { "uf120"       ,   19 } , //         0x13 -> HOME 

        { "u007f"       ,   20 } , //         0x14 -> DELETE
        { "UNDEFINED"   ,   21 } , //         0x15 -> UNDEFINED
        { "UNDEFINED"   ,   22 } , //         0x16 -> UNDEFINED
        { "UNDEFINED"   ,   23 } , //         0x17 -> UNDEFINED
        { "UNDEFINED"   ,   24 } , //         0x18 -> UNDEFINED
        { "UNDEFINED"   ,   25 } , //         0x19 -> UNDEFINED
        { "UNDEFINED"   ,   26 } , //         0x1A -> UNDEFINED
        { "UNDEFINED"   ,   27 } , //         0x1B -> UNDEFINED
        { "uf101"       ,   28 } , //         0x1C -> red 
        { "uf11d"       ,   29 } , //         0x1D -> CURSOR RIGHT 

        { "uf102"       ,   30 } , //         0x1E -> GREEN 
        { "uf103"       ,   31 } , //         0x1F -> BLUE 
        { " "           ,   32 } , //         0x20 -> SPACE
        { "!"           ,   33 } , //    !    0x21 -> !
        { "\""          ,   34 } , //   "    0x22 -> '
        { "#"           ,   35 } , //    #    0x23 -> #
        { "$"           ,   36 } , //    $    0x24 -> $
        { "%"           ,   37 } , //    %    0x25 -> %
        { "&"           ,   38 } , //    &    0x26 -> &
        { "'"           ,   39 } , //    '    0x27 -> '

        { "("           ,   40 } , //    (    0x28 -> (
        { ")"           ,   41 } , //    )    0x29 -> )
        { "*"           ,   42 } , //    *    0x2A -> *
        { "+"           ,   43 } , //    +    0x2B -> +
        { ","           ,   44 } , //    ,    0x2C -> ,
        { "-"           ,   45 } , //    -    0x2D -> -
        { "."           ,   46 } , //    .    0x2E -> .
        { "/"           ,   47 } , //    /    0x2F -> /
        { "0"           ,   48 } , //    0    0x30 -> 0
        { "1"           ,   49 } , //    1    0x31 -> 1

        { "2"           ,   50 } , //    2    0x32 -> 2
        { "3"           ,   51 } , //    3    0x33 -> 3
        { "4"           ,   52 } , //    4    0x34 -> 4
        { "5"           ,   53 } , //    5    0x35 -> 5
        { "6"           ,   54 } , //    6    0x36 -> 6
        { "7"           ,   55 } , //    7    0x37 -> 7
        { "8"           ,   56 } , //    8    0x38 -> 8
        { "9"           ,   57 } , //    9    0x39 -> 9
        { ":"           ,   58 } , //    :    0x3A -> :
        { ";"           ,   59 } , //    ;    0x3B -> ;

        { "<"           ,   60 } , //    <    0x3C -> <
        { "="           ,   61 } , //    =    0x3D -> =
        { ">"           ,   62 } , //    >    0x3E -> >
        { "?"           ,   63 } , //    ?    0x3F -> ?
        { "@"           ,   64 } , //    @    0x40 -> COMMERCIAL AT
        { "a"           ,   65 } , //    a    0x41 -> A
        { "b"           ,   66 } , //    b    0x42 -> B
        { "c"           ,   67 } , //    c    0x43 -> C
        { "d"           ,   68 } , //    d    0x44 -> D
        { "e"           ,   69 } , //    e    0x45 -> E

        { "f"           ,   70 } , //    f    0x46 -> F
        { "g"           ,   71 } , //    g    0x47 -> G
        { "h"           ,   72 } , //    h    0x48 -> H
        { "i"           ,   73 } , //    i    0x49 -> I
        { "j"           ,   74 } , //    j    0x4A -> J
        { "k"           ,   75 } , //    k    0x4B -> K
        { "l"           ,   76 } , //    l    0x4C -> L
        { "m"           ,   77 } , //    m    0x4D -> M
        { "n"           ,   78 } , //    n    0x4E -> N
        { "o"           ,   79 } , //    o    0x4F -> O

        { "p"           ,   80 } , //    p    0x50 -> P
        { "q"           ,   81 } , //    q    0x51 -> Q
        { "r"           ,   82 } , //    r    0x52 -> R
        { "s"           ,   83 } , //    s    0x53 -> S
        { "t"           ,   84 } , //    t    0x54 -> T
        { "u"           ,   85 } , //    u    0x55 -> U
        { "v"           ,   86 } , //    v    0x56 -> V
        { "w"           ,   87 } , //    w    0x57 -> W
        { "x"           ,   88 } , //    x    0x58 -> X
        { "y"           ,   89 } , //    y    0x59 -> Y

        { "z"           ,   90 } , //    z    0x5A -> Z
        { "["           ,   91 } , //    [    0x5B -> [
        { "u00a3"       ,   92 } , //    £    0x5C -> £
        { "]"           ,   93 } , //    ]    0x5D -> ]
        { "u2191"       ,   94 } , //    ↑    0x5E -> UPWARDS ARROW
        { "u2190"       ,   95 } , //    ←    0x5F -> LEFTWARDS ARROW
        { "u2500"       ,   96 } , //    ─    0x60 -> box LIGHT HORIZONTAL
        { "A"           ,   97 } , //    A    0x61 -> LATIN CAPITAL LETTER A
        { "B"           ,   98 } , //    B    0x62 -> LATIN CAPITAL LETTER B
        { "C"           ,   99 } , //    C    0x63 -> LATIN CAPITAL LETTER C

        { "D"           ,  100 } , //    D    0x64 -> LATIN CAPITAL LETTER D
        { "E"           ,  101 } , //    E    0x65 -> LATIN CAPITAL LETTER E
        { "F"           ,  102 } , //    F    0x66 -> LATIN CAPITAL LETTER F
        { "G"           ,  103 } , //    G    0x67 -> LATIN CAPITAL LETTER G
        { "H"           ,  104 } , //    H    0x68 -> LATIN CAPITAL LETTER H
        { "I"           ,  105 } , //    I    0x69 -> LATIN CAPITAL LETTER I
        { "J"           ,  106 } , //    J    0x6A -> LATIN CAPITAL LETTER J
        { "K"           ,  107 } , //    K    0x6B -> LATIN CAPITAL LETTER K
        { "L"           ,  108 } , //    L    0x6C -> LATIN CAPITAL LETTER L
        { "M"           ,  109 } , //    M    0x6D -> LATIN CAPITAL LETTER M

        { "N"           ,  110 } , //    N    0x6E -> LATIN CAPITAL LETTER N
        { "O"           ,  111 } , //    O    0x6F -> LATIN CAPITAL LETTER O
        { "P"           ,  112 } , //    P    0x70 -> LATIN CAPITAL LETTER P
        { "Q"           ,  113 } , //    Q    0x71 -> LATIN CAPITAL LETTER Q
        { "R"           ,  114 } , //    R    0x72 -> LATIN CAPITAL LETTER R
        { "S"           ,  115 } , //    S    0x73 -> LATIN CAPITAL LETTER S
        { "T"           ,  116 } , //    T    0x74 -> LATIN CAPITAL LETTER T
        { "U"           ,  117 } , //    U    0x75 -> LATIN CAPITAL LETTER U
        { "V"           ,  118 } , //    V    0x76 -> LATIN CAPITAL LETTER V
        { "W"           ,  119 } , //    W    0x77 -> LATIN CAPITAL LETTER W

        { "X"           ,  120 } , //    X    0x78 -> LATIN CAPITAL LETTER X
        { "Y"           ,  121 } , //    Y    0x79 -> LATIN CAPITAL LETTER Y
        { "Z"           ,  122 } , //    Z    0x7A -> LATIN CAPITAL LETTER Z
        { "u253c"       ,  123 } , //    ┼    0x7B -> box LIGHT VERTICAL AND HORIZONTAL
        { "uf12e"       ,  124 } , //        0x7C -> LEFT HALF BLOCK MEDIUM SHADE 
        { "u2502"       ,  125 } , //    │    0x7D -> box LIGHT VERTICAL
        { "u2592"       ,  126 } , //    ▒    0x7E -> MEDIUM SHADE
        { "uf139"       ,  127 } , //        0x7F -> MEDIUM SHADE SLASHED LEFT 
        { "UNDEFINED"   ,  128 } , //         0x80 -> UNDEFINED
        { "uf104"       ,  129 } , //         0x81 -> ORANGE 

        { "UNDEFINED"   ,  130 } , //         0x82 -> UNDEFINED
        { "UNDEFINED"   ,  131 } , //         0x83 -> UNDEFINED
        { "UNDEFINED"   ,  132 } , //         0x84 -> UNDEFINED
        { "uf110"       ,  133 } , //        0x85 -> FUNCTION KEY 1 
        { "uf112"       ,  134 } , //        0x86 -> FUNCTION KEY 3 
        { "uf114"       ,  135 } , //        0x87 -> FUNCTION KEY 5 
        { "uf116"       ,  136 } , //        0x88 -> FUNCTION KEY 7 
        { "uf111"       ,  137 } , //        0x89 -> FUNCTION KEY 2 
        { "uf113"       ,  138 } , //        0x8A -> FUNCTION KEY 4 
        { "uf115"       ,  139 } , //        0x8B -> FUNCTION KEY 6 

        { "uf117"       ,  140 } , //        0x8C -> FUNCTION KEY 8 
        { "\n"          ,  141 } , //         0x8D -> LINE FEED
        { "u000f"       ,  142 } , //        0x8E -> SHIFT IN
        { "UNDEFINED"   ,  143 } , //         0x8F -> UNDEFINED
        { "uf105"       ,  144 } , //         0x90 -> BLACK 
        { "uf11e"       ,  145 } , //        0x91 -> CURSOR UP 
        { "uf11b"       ,  146 } , //        0x92 -> reverse OFF 
        { "u000c"       ,  147 } , //         0x93 -> FORM FEED clear screen)
        { "uf121"       ,  148 } , //        0x94 -> INSERT 
        { "uf106"       ,  149 } , //         0x95 -> BROWN 

        { "uf107"       ,  150 } , //         0x96 -> LIGHT red 
        { "uf108"       ,  151 } , //         0x97 -> gray 1
        { "uf109"       ,  152 } , //        0x98 -> GRAY 2 
        { "uf10a"       ,  153 } , //        0x99 -> LIGHT GREEN 
        { "uf10b"       ,  154 } , //        0x9A -> LIGHT BLUE 
        { "uf10c"       ,  155 } , //        0x9B -> GRAY 3 
        { "uf10d"       ,  156 } , //        0x9C -> PURPLE 
        { "uf11d"       ,  157 } , //        0x9D -> CURSOR LEFT 
        { "uf10e"       ,  158 } , //        0x9E -> YELLOW 
        { "uf10f"       ,  159 } , //        0x9F -> CYAN 

        { "u00a0"       ,  160 } , //         0xA0 -> NO-BREAK SPACE
        { "u258c"       ,  161 } , //    ▌    0xA1 -> LEFT HALF BLOCK
        { "u2584"       ,  162 } , //    ▄    0xA2 -> LOWER HALF BLOCK
        { "u2594"       ,  163 } , //    ▔    0xA3 -> UPPER 1/8 BLOCK
        { "u2581"       ,  164 } , //    ▁    0xA4 -> LOWER 1/8 BLOCK
        { "u258f"       ,  165 } , //    ▏    0xA5 -> LEFT 1/8 BLOCK
        { "u2592"       ,  166 } , //    ▒    0xA6 -> MEDIUM SHADE
        { "u2595"       ,  167 } , //    ▕    0xA7 -> RIGHT 1/8 BLOCK
        { "uf12f"       ,  168 } , //        0xA8 -> LOWER HALF BLOCK MEDIUM SHADE 
        { "uf13a"       ,  169 } , //        0xA9 -> MEDIUM SHADE SLASHED RIGHT 

        { "uf130"       ,  170 } , //        0xAA -> RIGHT 1/4 BLOCK 
        { "u251c"       ,  171 } , //    ├    0xAB -> box LIGHT VERTICAL AND RIGHT
        { "u2597"       ,  172 } , //    ▗    0xAC -> QUADRANT LOWER RIGHT
        { "u2514"       ,  173 } , //    └    0xAD -> box LIGHT UP AND RIGHT
        { "u2510"       ,  174 } , //    ┐    0xAE -> box LIGHT DOWN AND LEFT
        { "u2582"       ,  175 } , //    ▂    0xAF -> LOWER 1/4 BLOCK
        { "u250c"       ,  176 } , //    ┌    0xB0 -> box LIGHT DOWN AND RIGHT
        { "u2534"       ,  177 } , //    ┴    0xB1 -> box LIGHT UP AND HORIZONTAL
        { "u252c"       ,  178 } , //    ┬    0xB2 -> box LIGHT DOWN AND HORIZONTAL
        { "u2524"       ,  179 } , //    ┤    0xB3 -> box LIGHT VERTICAL AND LEFT

        { "u258e"       ,  180 } , //    ▎    0xB4 -> LEFT 1/4 BLOCK
        { "u258d"       ,  181 } , //    ▍    0xB5 -> LEFT 3/8 BLOCK
        { "uf131"       ,  182 } , //        0xB6 -> RIGHT 3/8 BLOCK 
        { "uf132"       ,  183 } , //    🮂    0xB7 -> UPPER 1/4 BLOCK 
        { "uf133"       ,  184 } , //        0xB8 -> UPPER 3/8 BLOCK 
        { "u2583"       ,  185 } , //    ▃    0xB9 -> LOWER 3/8 BLOCK
        { "u2713"       ,  186 } , //    ✓    0xBA -> CHECK MARK
        { "u2596"       ,  187 } , //    ▖    0xBB -> QUADRANT LOWER LEFT
        { "u259d"       ,  188 } , //    ▝    0xBC -> QUADRANT UPPER RIGHT
        { "u2518"       ,  189 } , //    ┘    0xBD -> box LIGHT UP AND LEFT

        { "u2598"       ,  190 } , //    ▘    0xBE -> QUADRANT UPPER LEFT
        { "u259a"       ,  191 } , //    ▚    0xBF -> QUADRANT UPPER LEFT AND LOWER RIGHT
        { "u2500"       ,  192 } , //    ─    0xC0 -> box LIGHT HORIZONTAL

        { "A"           ,  193 } , //    A    0xC1 -> LATIN CAPITAL LETTER A
        { "B"           ,  194 } , //    B    0xC2 -> LATIN CAPITAL LETTER B
        { "C"           ,  195 } , //    C    0xC3 -> LATIN CAPITAL LETTER C
        { "D"           ,  196 } , //    D    0xC4 -> LATIN CAPITAL LETTER D
        { "E"           ,  197 } , //    E    0xC5 -> LATIN CAPITAL LETTER E
        { "F"           ,  198 } , //    F    0xC6 -> LATIN CAPITAL LETTER F
        { "G"           ,  199 } , //    G    0xC7 -> LATIN CAPITAL LETTER G

        { "H"           ,  200 } , //    H    0xC8 -> LATIN CAPITAL LETTER H
        { "I"           ,  201 } , //    I    0xC9 -> LATIN CAPITAL LETTER I
        { "J"           ,  202 } , //    J    0xCA -> LATIN CAPITAL LETTER J
        { "K"           ,  203 } , //    K    0xCB -> LATIN CAPITAL LETTER K
        { "L"           ,  204 } , //    L    0xCC -> LATIN CAPITAL LETTER L
        { "M"           ,  205 } , //    M    0xCD -> LATIN CAPITAL LETTER M
        { "N"           ,  206 } , //    N    0xCE -> LATIN CAPITAL LETTER N
        { "O"           ,  207 } , //    O    0xCF -> LATIN CAPITAL LETTER O
        { "P"           ,  208 } , //    P    0xD0 -> LATIN CAPITAL LETTER P
        { "Q"           ,  209 } , //    Q    0xD1 -> LATIN CAPITAL LETTER Q

        { "R"           ,  210 } , //    R    0xD2 -> LATIN CAPITAL LETTER R
        { "S"           ,  211 } , //    S    0xD3 -> LATIN CAPITAL LETTER S
        { "T"           ,  212 } , //    T    0xD4 -> LATIN CAPITAL LETTER T
        { "U"           ,  213 } , //    U    0xD5 -> LATIN CAPITAL LETTER U
        { "V"           ,  214 } , //    V    0xD6 -> LATIN CAPITAL LETTER V
        { "W"           ,  215 } , //    W    0xD7 -> LATIN CAPITAL LETTER W
        { "X"           ,  215 } , //    X    0xD8 -> LATIN CAPITAL LETTER X
        { "Y"           ,  217 } , //    Y    0xD9 -> LATIN CAPITAL LETTER Y
        { "Z"           ,  218 } , //    Z    0xDA -> LATIN CAPITAL LETTER Z
        { "u253c"       ,  219 } , //    ┼    0xDB -> box LIGHT VERTICAL AND HORIZONTAL

        { "uf12e"       ,  220 } , //        0xDC -> LEFT HALF BLOCK MEDIUM SHADE 
        { "u2502"       ,  221 } , //    │    0xDD -> box LIGHT VERTICAL
        { "u2592"       ,  222 } , //    ▒    0xDE -> MEDIUM SHADE
        { "uf139"       ,  223 } , //        0xDF -> MEDIUM SHADE SLASHED LEFT 
        { "u00a0"       ,  224 } , //         0xE0 -> NO-BREAK SPACE
        { "u258c"       ,  225 } , //    ▌    0xE1 -> LEFT HALF BLOCK
        { "u2584"       ,  226 } , //    ▄    0xE2 -> LOWER HALF BLOCK
        { "u2594"       ,  227 } , //    ▔    0xE3 -> UPPER 1/8 BLOCK
        { "u2581"       ,  228 } , //    ▁    0xE4 -> LOWER 1/8 BLOCK
        { "u258f"       ,  229 } , //    ▏    0xE5 -> LEFT 1/8 BLOCK

        { "u2592"       ,  230 } , //    ▒    0xE6 -> MEDIUM SHADE
        { "u2595"       ,  231 } , //    ▕    0xE7 -> RIGHT 1/8 BLOCK
        { "uf12f"       ,  232 } , //        0xE8 -> LOWER HALF BLOCK MEDIUM SHADE 
        { "uf13a"       ,  233 } , //        0xE9 -> MEDIUM SHADE SLASHED RIGHT 
        { "uf130"       ,  234 } , //    🮇    0xEA -> RIGHT 1/4 BLOCK 
        { "u251c"       ,  235 } , //    ├    0xEB -> box LIGHT VERTICAL AND RIGHT
        { "u2597"       ,  236 } , //    ▗    0xEC -> QUADRANT LOWER RIGHT
        { "u2514"       ,  237 } , //    └    0xED -> box LIGHT UP AND RIGHT
        { "u2510"       ,  238 } , //    ┐    0xEE -> box LIGHT DOWN AND LEFT
        { "u2582"       ,  239 } , //    ▂    0xEF -> LOWER 1/4 BLOCK

        { "u250c"       ,  240 } , //    ┌    0xF0 -> box LIGHT DOWN AND RIGHT
        { "u2534"       ,  241 } , //    ┴    0xF1 -> box LIGHT UP AND HORIZONTAL
        { "u252c"       ,  242 } , //    ┬    0xF2 -> box LIGHT DOWN AND HORIZONTAL
        { "u2524"       ,  243 } , //    ┤    0xF3 -> box LIGHT VERTICAL AND LEFT
        { "u258e"       ,  244 } , //    ▎    0xF4 -> LEFT 1/4 BLOCK
        { "u258d"       ,  245 } , //    ▍    0xF5 -> LEFT 3/8 BLOCK
        { "uf131"       ,  246 } , //        0xF6 -> RIGHT 3/8 BLOCK 
        { "uf132"       ,  247 } , //        0xF7 -> UPPER 1/4 BLOCK 
        { "uf133"       ,  248 } , //        0xF8 -> UPPER 3/8 BLOCK 
        { "u2583"       ,  249 } , //    ▃    0xF9 -> LOWER 3/8 BLOCK

        { "u2713"       ,  250 } , //    ✓    0xFA -> CHECK MARK
        { "u2596"       ,  251 } , //    ▖    0xFB -> QUADRANT LOWER LEFT
        { "u259d"       ,  252 } , //    ▝    0xFC -> QUADRANT UPPER RIGHT
        { "u2518"       ,  254 } , //    ┘    0xFD -> box LIGHT UP AND LEFT
        { "u2598"       ,  254 } , //    ▘    0xFE -> QUADRANT UPPER LEFT
        { "u2592"       ,  255 } ,   //  ▒    0xFF -> pi

} ;

std::map<std::string,unsigned char> c64PetsciiNamesLowerCase =
{
        { "u0000"                                   ,    0 } , //         0x00 -> u0000
        { "undefined"                               ,    1 } , //         0x01 -> undefined
        { "undefined"                               ,    2 } , //         0x02 -> undefined
        { "undefined"                               ,    3 } , //         0x03 -> undefined
        { "undefined"                               ,    4 } , //         0x04 -> undefined
        { "white"                                   ,    5 } , //         0x05 -> white 
        { "undefined"                               ,    6 } , //         0x06 -> undefined
        { "undefined"                               ,    7 } , //         0x07 -> undefined
        { "disable character set switching"         ,    8 } , //         0x08 -> disable character set switching 
        { "enable character set switching"          ,    9 } , //         0x09 -> enable character set switching 

        { "undefined"                               ,   10 } , //         0x0a -> undefined
        { "undefined"                               ,   11 } , //         0x0b -> undefined
        { "undefined"                               ,   12 } , //         0x0c -> undefined
        { "\r"                                      ,   13 } , //         0x0d -> carriage return
        { "shift out"                               ,   14 } , //         0x0e -> shift out
        { "undefined"                               ,   15 } , //         0x0f -> undefined
        { "undefined"                               ,   16 } , //         0x10 -> undefined
        { "cursor down"                             ,   17 } , //         0x11 -> cursor down 
        { "reverse on"                              ,   18 } , //         0x12 -> reverse on 
        { "home"                                    ,   19 } , //         0x13 -> home 

        { "delete"                                  ,   20 } , //         0x14 -> delete
        { "undefined"                               ,   21 } , //         0x15 -> undefined
        { "undefined"                               ,   22 } , //         0x16 -> undefined
        { "undefined"                               ,   23 } , //         0x17 -> undefined
        { "undefined"                               ,   24 } , //         0x18 -> undefined
        { "undefined"                               ,   25 } , //         0x19 -> undefined
        { "undefined"                               ,   26 } , //         0x1a -> undefined
        { "undefined"                               ,   27 } , //         0x1b -> undefined
        { "red"                                     ,   28 } , //         0x1c -> red 
        { "cursor right"                            ,   29 } , //         0x1d -> cursor right 

        { "green"                                   ,   30 } , //         0x1e -> green 
        { "blue"                                    ,   31 } , //         0x1f -> blue 
        { " "                           ,   32 } , //         0x20 -> space
        { "!"                           ,   33 } , //    !    0x21 -> !
        { "\""                          ,   34 } , //   "    0x22 -> '
        { "#"                           ,   35 } , //    #    0x23 -> #
        { "$"                           ,   36 } , //    $    0x24 -> $
        { "%"                           ,   37 } , //    %    0x25 -> %
        { "&"                           ,   38 } , //    &    0x26 -> &
        { "'"                           ,   39 } , //    '    0x27 -> '

        { "("                           ,   40 } , //    (    0x28 -> (
        { ")"                           ,   41 } , //    )    0x29 -> )
        { "*"                           ,   42 } , //    *    0x2a -> *
        { "+"                           ,   43 } , //    +    0x2b -> +
        { ","                           ,   44 } , //    ,    0x2c -> ,
        { "-"                           ,   45 } , //    -    0x2d -> -
        { "."                           ,   46 } , //    .    0x2e -> .
        { "/"                           ,   47 } , //    /    0x2f -> /
        { "0"                               ,   48 } , //    0    0x30 -> 0
        { "1"                               ,   49 } , //    1    0x31 -> 1

        { "2"                               ,   50 } , //    2    0x32 -> 2
        { "3"                               ,   51 } , //    3    0x33 -> 3
        { "4"                               ,   52 } , //    4    0x34 -> 4
        { "5"                               ,   53 } , //    5    0x35 -> 5
        { "6"                               ,   54 } , //    6    0x36 -> 6
        { "7"                               ,   55 } , //    7    0x37 -> 7
        { "8"                               ,   56 } , //    8    0x38 -> 8
        { "9"                               ,   57 } , //    9    0x39 -> 9
        { ":"                               ,   58 } , //    :    0x3a -> :
        { ";"                               ,   59 } , //    ;    0x3b -> ;

        { "<"                               ,   60 } , //    <    0x3c -> <
        { "="                               ,   61 } , //    =    0x3d -> =
        { ">"                               ,   62 } , //    >    0x3e -> >
        { "?"                               ,   63 } , //    ?    0x3f -> ?
        { "@"                               ,   64 } , //    @    0x40 -> commercial at
        
        { "a"                    ,   65 } , //    a    0x41 -> a
        { "b"                    ,   66 } , //    b    0x42 -> b
        { "c"                    ,   67 } , //    c    0x43 -> c
        { "d"                    ,   68 } , //    d    0x44 -> d
        { "e"                    ,   69 } , //    e    0x45 -> e

        { "f"                    ,   70 } , //    f    0x46 -> f
        { "g"                    ,   71 } , //    g    0x47 -> g
        { "h"                    ,   72 } , //    h    0x48 -> h
        { "i"                    ,   73 } , //    i    0x49 -> i
        { "j"                    ,   74 } , //    j    0x4a -> j
        { "k"                    ,   75 } , //    k    0x4b -> k
        { "l"                    ,   76 } , //    l    0x4c -> l
        { "m"                    ,   77 } , //    m    0x4d -> m
        { "n"                    ,   78 } , //    n    0x4e -> n
        { "o"                    ,   79 } , //    o    0x4f -> o

        { "p"                    ,   80 } , //    p    0x50 -> p
        { "q"                    ,   81 } , //    q    0x51 -> q
        { "r"                    ,   82 } , //    r    0x52 -> r
        { "s"                    ,   83 } , //    s    0x53 -> s
        { "t"                    ,   84 } , //    t    0x54 -> t
        { "u"                    ,   85 } , //    u    0x55 -> u
        { "v"                    ,   86 } , //    v    0x56 -> v
        { "w"                    ,   87 } , //    w    0x57 -> w
        { "x"                    ,   88 } , //    x    0x58 -> x
        { "y"                    ,   89 } , //    y    0x59 -> y

        { "z"                    ,   90 } , //    z    0x5a -> z

        { "["                    ,   91 } , //    [    0x5b -> [
        { "£"                    ,   92 } , //    £    0x5c -> £
        { "]"                    ,   93 } , //    ]    0x5d -> ]
        { "upwards arrow"        ,   94 } , //    ↑    0x5e -> upwards arrow
        { "leftwards arrow"      ,   95 } , //    ←    0x5f -> leftwards arrow
        { "box light horizontal" ,   96 } , //    ─    0x60 -> box light horizontal
        
        { "A"                  ,   97 } , //    a    0x61 -> latin capital letter a
        { "B"                  ,   98 } , //    b    0x62 -> latin capital letter b
        { "C"                  ,   99 } , //    c    0x63 -> latin capital letter c

        { "D"                  ,  100 } , //    d    0x64 -> latin capital letter d
        { "E"                  ,  101 } , //    e    0x65 -> latin capital letter e
        { "F"                  ,  102 } , //    f    0x66 -> latin capital letter f
        { "G"                  ,  103 } , //    g    0x67 -> latin capital letter g
        { "H"                  ,  104 } , //    h    0x68 -> latin capital letter h
        { "I"                  ,  105 } , //    i    0x69 -> latin capital letter i
        { "J"                  ,  106 } , //    j    0x6a -> latin capital letter j
        { "K"                  ,  107 } , //    k    0x6b -> latin capital letter j
        { "L"                  ,  108 } , //    l    0x6c -> latin capital letter l
        { "M"                  ,  109 } , //    m    0x6d -> latin capital letter m

        { "N"                  ,  110 } , //    n    0x6e -> latin capital letter n
        { "O"                  ,  111 } , //    o    0x6f -> latin capital letter o
        { "P"                  ,  112 } , //    p    0x70 -> latin capital letter p
        { "Q"                  ,  113 } , //    q    0x71 -> latin capital letter q
        { "R"                  ,  114 } , //    r    0x72 -> latin capital letter r
        { "S"                  ,  115 } , //    s    0x73 -> latin capital letter s
        { "T"                  ,  116 } , //    t    0x74 -> latin capital letter t
        { "U"                  ,  117 } , //    u    0x75 -> latin capital letter u
        { "V"                  ,  118 } , //    v    0x76 -> latin capital letter v
        { "W"                  ,  119 } , //    w    0x77 -> latin capital letter w

        { "X"                  ,  120 } , //    x    0x78 -> latin capital letter x
        { "Y"                  ,  121 } , //    y    0x79 -> latin capital letter y
        { "Z"                  ,  122 } , //    z    0x7a -> latin capital letter z
        
        { "box light vertical and horizontal"           ,  123 } , //    ┼    0x7b -> box light vertical and horizontal
        { "left half block medium shade"                ,  124 } , //        0x7c -> left half block medium shade 
        { "box light vertical"                          ,  125 } , //    │    0x7d -> box light vertical
        { "medium shade"                                ,  126 } , //    ▒    0x7e -> medium shade
        { "medium shade slashed left"                   ,  127 } , //        0x7f -> medium shade slashed left 
        { "undefined"                                   ,  128 } , //         0x80 -> undefined
        { "orange"                                      ,  129 } , //         0x81 -> orange 

        { "undefined"                                   ,  130 } , //         0x82 -> undefined
        { "undefined"                                   ,  131 } , //         0x83 -> undefined
        { "undefined"                                   ,  132 } , //         0x84 -> undefined
        
        { "f1"                    ,  133 } , //        0x85 -> function key 1 
        { "f3"                    ,  134 } , //        0x86 -> function key 3 
        { "f5"                    ,  135 } , //        0x87 -> function key 5 
        { "f7"                    ,  136 } , //        0x88 -> function key 7 
        { "f2"                    ,  137 } , //        0x89 -> function key 2 
        { "f4"                    ,  138 } , //        0x8a -> function key 4 
        { "f6"                    ,  139 } , //        0x8b -> function key 6 
        { "f8"                    ,  140 } , //        0x8c -> function key 8 
        
        { "\n"                          ,  141 } , //         0x8d -> line feed
        { "shift in"                    ,  142 } , //       0x8e -> shift in
        { "undefined"                   ,  143 } , //         0x8f -> undefined
        { "black"                       ,  144 } , //         0x90 -> black 
        { "cursor up"                   ,  145 } , //        0x91 -> cursor up 
        { "reverse off"                 ,  146 } , //        0x92 -> reverse off 
        { "form feed clear screen"      ,  147 } , //         0x93 -> form feed clear screen
        
        { "insert"               ,  148 } , //        0x94 -> insert 
        { "brown"                ,  149 } , //         0x95 -> brown 

        { "light red"            ,  150 } , //         0x96 -> light red 
        { "gray 1"               ,  151 } , //         0x97 -> gray 1
        { "gray 2"               ,  152 } , //        0x98 -> gray 2 
        { "light green"          ,  153 } , //        0x99 -> light green 
        { "light blue"           ,  154 } , //        0x9a -> light blue 
        { "gray 3"               ,  155 } , //        0x9b -> gray 3 
        { "purple"               ,  156 } , //        0x9c -> purple 
        { "cursor left"          ,  157 } , //        0x9d -> cursor left 
        { "yellow"               ,  158 } , //        0x9e -> yellow 
        { "cyan"                 ,  159 } , //        0x9f -> cyan 
        
        { "no-break space"                      ,  160 } , //         0xa0 -> no-break space
        { "left half block"                     ,  161 } , //    ▌    0xa1 -> left half block
        { "lower half block"                    ,  162 } , //    ▄    0xa2 -> lower half block
        { "upper 1/8 block"                     ,  163 } , //    ▔    0xa3 -> upper 1/8 block
        { "lower 1/8 block1"                    ,  164 } , //    ▁    0xa4 -> lower 1/8 block
        { "left 1/8 block"                      ,  165 } , //    ▏    0xa5 -> left 1/8 block
        { "medium shade"                        ,  166 } , //    ▒    0xa6 -> medium shade
        { "right 1/8 block"                     ,  167 } , //    ▕    0xa7 -> right 1/8 block
        { "lower half block medium shade"       ,  168 } , //        0xa8 -> lower half block medium shade 
        { "medium shade slashed right"          ,  169 } , //        0xa9 -> medium shade slashed right 

        { "right 1/4 block"                     ,  170 } , //        0xaa -> right 1/4 block 
        { "box light vertical and right"        ,  171 } , //    ├    0xab -> box light vertical and right
        { "quadrant lower right"                ,  172 } , //    ▗    0xac -> quadrant lower right
        { "box light up and right"              ,  173 } , //    └    0xad -> box light up and right
        { "box light down and left"             ,  174 } , //    ┐    0xae -> box light down and left
        { "lower 1/4 block"                     ,  175 } , //    ▂    0xaf -> lower 1/4 block
        { "box light down and right"            ,  176 } , //    ┌    0xb0 -> box light down and right
        { "box light up and horizontal"         ,  177 } , //    ┴    0xb1 -> box light up and horizontal
        { "box light down and horizontal"       ,  178 } , //    ┬    0xb2 -> box light down and horizontal
        { "box light vertical and left"         ,  179 } , //    ┤    0xb3 -> box light vertical and left

        { "left 1/4 block"                      ,  180 } , //    ▎    0xb4 -> left 1/4 block
        { "left 3/8 block"                      ,  181 } , //    ▍    0xb5 -> left 3/8 block
        { "right 3/8 block"                     ,  182 } , //        0xb6 -> right 3/8 block 
        { "upper 1/4 block"                     ,  183 } , //    🮂    0xb7 -> upper 1/4 block 
        { "upper 3/8 block "                    ,  184 } , //        0xb8 -> upper 3/8 block 
        { "lower 3/8 block"                     ,  185 } , //    ▃    0xb9 -> lower 3/8 block
        { "check mark"                          ,  186 } , //    ✓    0xba -> check mark
        { "quadrant lower left"                 ,  187 } , //    ▖    0xbb -> quadrant lower left
        { "quadrant upper right"                ,  188 } , //    ▝    0xbc -> quadrant upper right
        { "box light up and left"               ,  189 } , //    ┘    0xbd -> box light up and left
        { "quadrant upper left"                 ,  190 } , //    ▘    0xbe -> quadrant upper left

        { "quadrant upper left and lower right" ,  191 } , //    ▚    0xbf -> quadrant upper left and lower right
        { "box light horizontal"                ,  192 } , //    ─    0xc0 -> box light horizontal
        
        { "A"                  ,  193 } , //    a    0xc1 -> latin capital letter a
        { "B"                  ,  194 } , //    b    0xc2 -> latin capital letter b
        { "C"                  ,  195 } , //    c    0xc3 -> latin capital letter c
        { "D"                  ,  196 } , //    d    0xc4 -> latin capital letter d
        { "E"                  ,  197 } , //    e    0xc5 -> latin capital letter e
        { "F"                  ,  198 } , //    f    0xc6 -> latin capital letter f
        { "G"                  ,  199 } , //    g    0xc7 -> latin capital letter g

        { "H"                  ,  200 } , //    h    0xc8 -> latin capital letter h
        { "I"                  ,  201 } , //    i    0xc9 -> latin capital letter i
        { "J"                  ,  202 } , //    j    0xca -> latin capital letter j
        { "K"                  ,  203 } , //    k    0xcb -> latin capital letter k
        { "L"                  ,  204 } , //    l    0xcc -> latin capital letter l
        { "M"                  ,  205 } , //    m    0xcd -> latin capital letter m
        { "N"                  ,  206 } , //    n    0xce -> latin capital letter n
        { "O"                  ,  207 } , //    o    0xcf -> latin capital letter o
        { "P"                  ,  208 } , //    p    0xd0 -> latin capital letter p
        { "Q"                  ,  209 } , //    q    0xd1 -> latin capital letter q

        { "R"                  ,  210 } , //    r    0xd2 -> latin capital letter r
        { "S"                  ,  211 } , //    s    0xd3 -> latin capital letter s
        { "T"                  ,  212 } , //    t    0xd4 -> latin capital letter t
        { "U"                  ,  213 } , //    u    0xd5 -> latin capital letter u
        { "V"                  ,  214 } , //    v    0xd6 -> latin capital letter v
        { "W"                  ,  215 } , //    w    0xd7 -> latin capital letter w
        { "X"                  ,  215 } , //    x    0xd8 -> latin capital letter x
        { "Y"                  ,  217 } , //    y    0xd9 -> latin capital letter y
        { "Z"                  ,  218 } , //    z    0xda -> latin capital letter z
        { "box light vertical and horizontal"   ,  219 } , //    ┼    0xdb -> box light vertical and horizontal

        { "left half block medium shade"        ,  220 } , //        0xdc -> left half block medium shade 
        { "box light vertical"                  ,  221 } , //    │    0xdd -> box light vertical
        { "medium shade"                        ,  222 } , //    ▒    0xde -> medium shade
        { "medium shade slashed left"           ,  223 } , //        0xdf -> medium shade slashed left 
        { "no-break space"                      ,  224 } , //         0xe0 -> no-break space
        { "left half block"                     ,  225 } , //    ▌    0xe1 -> left half block
        { "lower half block"                    ,  226 } , //    ▄    0xe2 -> lower half block
        { "upper 1/8 block"                     ,  227 } , //    ▔    0xe3 -> upper 1/8 block
        { "lower 1/8 block"                     ,  228 } , //    ▁    0xe4 -> lower 1/8 block
        { "left 1/8 block"                      ,  229 } , //    ▏    0xe5 -> left 1/8 block

        { "medium shade"                        ,  230 } , //    ▒    0xe6 -> medium shade
        { "right 1/8 block"                     ,  231 } , //    ▕    0xe7 -> right 1/8 block
        { "lower half block medium shade"       ,  232 } , //        0xe8 -> lower half block medium shade 
        { "medium shade slashed right "         ,  233 } , //        0xe9 -> medium shade slashed right 
        { "right 1/4 block"                     ,  234 } , //    🮇    0xea -> right 1/4 block 
        { "box light vertical and right"        ,  235 } , //    ├    0xeb -> box light vertical and right
        { "quadrant lower right"                ,  236 } , //    ▗    0xec -> quadrant lower right
        { "box light up and right"              ,  237 } , //    └    0xed -> box light up and right
        { "box light down and left"             ,  238 } , //    ┐    0xee -> box light down and left
        { "lower 1/4 block"                     ,  239 } , //    ▂    0xef -> lower 1/4 block

        { "box light down and right"            ,  240 } , //    ┌    0xf0 -> box light down and right
        { "box light up and horizontal"         ,  241 } , //    ┴    0xf1 -> box light up and horizontal
        { "box light down and horizontal"       ,  242 } , //    ┬    0xf2 -> box light down and horizontal
        { "box light vertical and left"         ,  243 } , //    ┤    0xf3 -> box light vertical and left
        { "left 1/4 block"                      ,  244 } , //    ▎    0xf4 -> left 1/4 block
        { "left 3/8 block"                      ,  245 } , //    ▍    0xf5 -> left 3/8 block
        { "right 3/8 block"                     ,  246 } , //        0xf6 -> right 3/8 block 
        { "upper 1/4 block"                     ,  247 } , //        0xf7 -> upper 1/4 block 
        { "upper 3/8 block"                     ,  248 } , //        0xf8 -> upper 3/8 block 
        { "lower 3/8 block"                     ,  249 } , //    ▃    0xf9 -> lower 3/8 block

        { "check mark"                          ,  250 } , //    ✓    0xfa -> check mark
        { "quadrant lower left"                 ,  251 } , //    ▖    0xfb -> quadrant lower left
        { "quadrant upper right"                ,  252 } , //    ▝    0xfc -> quadrant upper right
        { "box light up and left"               ,  254 } , //    ┘    0xfd -> box light up and left
        { "quadrant upper left"                 ,  254 } , //    ▘    0xfe -> quadrant upper left
        { "pi"                                  ,  255 } , //    π    0xff -> pi

} ;

std::map<std::string,unsigned char> c64PetsciiCodesUpperCase =
{
      { "u0000" ,        0 } , //       0x00 -> \u0000
      { "ufffe" ,        1 } , //       0x01 -> UNDEFINED
      { "ufffe" ,        2 } , //       0x02 -> UNDEFINED
      { "ufffe" ,        3 } , //       0x03 -> UNDEFINED
      { "ufffe" ,        4 } , //       0x04 -> UNDEFINED
      { "uf100" ,        5 } , //       0x05 -> white 
      { "ufffe" ,        6 } , //       0x06 -> UNDEFINED
      { "ufffe" ,        7 } , //       0x07 -> UNDEFINED
      { "uf118" ,        8 } , //       0x08 -> DISABLE CHARACTER SET SWITCHING 
      { "uf119" ,        9 } , //       0x09 -> ENABLE CHARACTER SET SWITCHING 

      { "ufffe" ,       10 } , //       0x0A -> UNDEFINED
      { "ufffe" ,       11 } , //       0x0B -> UNDEFINED
      { "ufffe" ,       12 } , //       0x0C -> UNDEFINED
      { "\r"    ,       13 } , //       0x0D -> CARRIAGE RETURN
      { "u000e" ,       14 } , //       0x0E -> SHIFT OUT
      { "ufffe" ,       15 } , //       0x0F -> UNDEFINED
      { "ufffe" ,       16 } , //       0x10 -> UNDEFINED
      { "uf11c" ,       17 } , //       0x11 -> CURSOR DOWN 
      { "uf11a" ,       18 } , //       0x12 -> reverse ON 
      { "uf120" ,       19 } , //       0x13 -> HOME 

      { "u007f" ,       20 } , //       0x14 -> DELETE
      { "ufffe" ,       21 } , //       0x15 -> UNDEFINED
      { "ufffe" ,       22 } , //       0x16 -> UNDEFINED
      { "ufffe" ,       23 } , //       0x17 -> UNDEFINED
      { "ufffe" ,       24 } , //       0x18 -> UNDEFINED
      { "ufffe" ,       25 } , //       0x19 -> UNDEFINED
      { "ufffe" ,       26 } , //       0x1A -> UNDEFINED
      { "ufffe" ,       27 } , //       0x1B -> UNDEFINED
      { "uf101" ,       28 } , //       0x1C -> red 
      { "uf11d" ,       29 } , //       0x1D -> CURSOR RIGHT 

      { "uf102" ,       30 } , //       0x1E -> GREEN 
      { "uf103" ,       31 } , //       0x1F -> BLUE 
      { " "     ,       32 } , //       0x20 -> SPACE
      { "!"     ,       33 } , //  !    0x21 -> !
      { "\""    ,       34 } , //  "    0x22 -> '
      { "#"     ,       35 } , //  #    0x23 -> #
      { "$"     ,       36 } , //  $    0x24 -> $
      { "%"     ,       37 } , //  %    0x25 -> %
      { "&"     ,       38 } , //  &    0x26 -> &
      { "'"     ,       39 } , //  '    0x27 -> '

      { "("     ,       40 } , //  (    0x28 -> (
      { ")"     ,       41 } , //  )    0x29 -> )
      { "*"     ,       42 } , //  *    0x2A -> *
      { "+"     ,       43 } , //  +    0x2B -> +
      { ","     ,       44 } , //  ,    0x2C -> ,
      { "-"     ,       45 } , //  -    0x2D -> -
      { "."     ,       46 } , //  .    0x2E -> .
      { "/"     ,       47 } , //  /    0x2F -> /
      { "0"     ,       48 } , //  0    0x30 -> 0
      { "1"     ,       49 } , //  1    0x31 -> 1

      { "2"     ,       50 } , //  2    0x32 -> 2
      { "3"     ,       51 } , //  3    0x33 -> 3
      { "4"     ,       52 } , //  4    0x34 -> 4
      { "5"     ,       53 } , //  5    0x35 -> 5
      { "6"     ,       54 } , //  6    0x36 -> 6
      { "7"     ,       55 } , //  7    0x37 -> 7
      { "8"     ,       56 } , //  8    0x38 -> 8
      { "9"     ,       57 } , //  9    0x39 -> 9
      { ":"     ,       58 } , //  :    0x3A -> :
      { ";"     ,       59 } , //  ;    0x3B -> ;

      { "<"     ,       60 } , //  <    0x3C -> <
      { "="     ,       61 } , //  =    0x3D -> =
      { ">"     ,       62 } , //  >    0x3E -> >
      { "?"     ,       63 } , //  ?    0x3F -> ?
      { "@"     ,       64 } , //  @    0x40 -> COMMERCIAL AT
      { "A"     ,       65 } , //  A    0x41 -> LATIN CAPITAL LETTER A
      { "B"     ,       66 } , //  B    0x42 -> LATIN CAPITAL LETTER B
      { "C"     ,       67 } , //  C    0x43 -> LATIN CAPITAL LETTER C
      { "D"     ,       68 } , //  D    0x44 -> LATIN CAPITAL LETTER D
      { "E"     ,       69 } , //  E    0x45 -> LATIN CAPITAL LETTER E

      { "F"     ,       70 } , //  F    0x46 -> LATIN CAPITAL LETTER F
      { "G"     ,       71 } , //  G    0x47 -> LATIN CAPITAL LETTER G
      { "H"     ,       72 } , //  H    0x48 -> LATIN CAPITAL LETTER H
      { "I"     ,       73 } , //  I    0x49 -> LATIN CAPITAL LETTER I
      { "J"     ,       74 } , //  J    0x4A -> LATIN CAPITAL LETTER J
      { "K"     ,       75 } , //  K    0x4B -> LATIN CAPITAL LETTER K
      { "L"     ,       76 } , //  L    0x4C -> LATIN CAPITAL LETTER L
      { "M"     ,       77 } , //  M    0x4D -> LATIN CAPITAL LETTER M
      { "N"     ,       78 } , //  N    0x4E -> LATIN CAPITAL LETTER N
      { "O"     ,       79 } , //  O    0x4F -> LATIN CAPITAL LETTER O

      { "P"     ,       80 } , //  P    0x50 -> LATIN CAPITAL LETTER P
      { "Q"     ,       81 } , //  Q    0x51 -> LATIN CAPITAL LETTER Q
      { "R"     ,       82 } , //  R    0x52 -> LATIN CAPITAL LETTER R
      { "S"     ,       83 } , //  S    0x53 -> LATIN CAPITAL LETTER S
      { "T"     ,       84 } , //  T    0x54 -> LATIN CAPITAL LETTER T
      { "U"     ,       85 } , //  U    0x55 -> LATIN CAPITAL LETTER U
      { "V"     ,       86 } , //  V    0x56 -> LATIN CAPITAL LETTER V
      { "W"     ,       87 } , //  W    0x57 -> LATIN CAPITAL LETTER W
      { "X"     ,       88 } , //  X    0x58 -> LATIN CAPITAL LETTER X
      { "Y"     ,       89 } , //  Y    0x59 -> LATIN CAPITAL LETTER Y

      { "Z"     ,       90 } , //  Z    0x5A -> LATIN CAPITAL LETTER Z
      { "["     ,       91 } , //  [    0x5B -> [
      { "u00a3" ,       92 } , //  £    0x5C -> £
      { "]"     ,       93 } , //  ]    0x5D -> ]
      { "u2191" ,       94 } , //  ↑    0x5E -> UPWARDS ARROW
      { "u2190" ,       95 } , //  ←    0x5F -> LEFTWARDS ARROW
      { "u2500" ,       96 } , //  ─    0x60 -> box LIGHT HORIZONTAL
      { "u2660" ,       97 } , //  ♠    0x61 -> BLACK SPADE SUIT
      { "uf13c" ,       98 } , //  │    0x62 -> box LIGHT VERTICAL 1/8 LEFT 
      { "uf13b" ,       99 } , //  ─    0x63 -> box LIGHT HORIZONTAL 1/8 UP 

      { "uf122" ,      100 } , //      0x64 -> box LIGHT HORIZONTAL 2/8 UP 
      { "uf123" ,      101 } , //      0x65 -> box LIGHT HORIZONTAL 3/8 UP 
      { "uf124" ,      102 } , //      0x66 -> box LIGHT HORIZONTAL 1/8 DOWN 
      { "uf126" ,      103 } , //      0x67 -> box LIGHT VERTICAL 2/8 LEFT 
      { "uf128" ,      104 } , //      0x68 -> box LIGHT VERTICAL 1/8 RIGHT 
      { "u256e" ,      105 } , //  ╮    0x69 -> box LIGHT ARC DOWN AND LEFT
      { "u2570" ,      106 } , //  ╰    0x6A -> box LIGHT ARC UP AND RIGHT
      { "u256f" ,      107 } , //  ╯    0x6B -> box LIGHT ARC UP AND LEFT
      { "uf12a" ,      108 } , //      0x6C -> 1/8 BLOCK UP AND RIGHT 
      { "u2572" ,      109 } , //  ╲    0x6D -> box LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT

      { "u2571" ,      110 } , //  ╱    0x6E -> box LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
      { "uf12b" ,      111 } , //      0x6F -> 1/8 BLOCK DOWN AND RIGHT 
      { "uf12c" ,      112 } , //      0x70 -> 1/8 BLOCK DOWN AND LEFT 
      { "u25cf" ,      113 } , //  ●    0x71 -> BLACK CIRCLE
      { "uf125" ,      114 } , //      0x72 -> box LIGHT HORIZONTAL 2/8 DOWN 
      { "u2665" ,      115 } , //  ♥    0x73 -> BLACK HEART SUIT
      { "uf127" ,      116 } , //      0x74 -> box LIGHT VERTICAL 3/8 LEFT 
      { "u256d" ,      117 } , //  ╭    0x75 -> box LIGHT ARC DOWN AND RIGHT
      { "u2573" ,      118 } , //  ╳    0x76 -> box LIGHT DIAGONAL CROSS
      { "u25cb" ,      119 } , //  ○    0x77 -> WHITE CIRCLE

      { "u2663" ,      120 } , //  ♣    0x78 -> BLACK CLUB SUIT
      { "uf129" ,      121 } , //      0x79 -> box LIGHT VERTICAL 2/8 RIGHT 
      { "u2666" ,      122 } , //  ♦    0x7A -> BLACK DIAMOND SUIT
      { "u253c" ,      123 } , //  ┼    0x7B -> box LIGHT VERTICAL AND HORIZONTAL
      { "uf12e" ,      124 } , //      0x7C -> LEFT HALF BLOCK MEDIUM SHADE 
      { "u2502" ,      125 } , //  │    0x7D -> box LIGHT VERTICAL
      { "u03c0" ,      126 } , //  π    0x7E -> pi
      { "u25e5" ,      127 } , //  ◥    0x7F -> BLACK UPPER RIGHT TRIANGLE
      { "ufffe" ,      128 } , //       0x80 -> UNDEFINED
      { "uf104" ,      129 } , //      0x81 -> ORANGE 

      { "ufffe" ,      130 } , //       0x82 -> UNDEFINED
      { "ufffe" ,      131 } , //       0x83 -> UNDEFINED
      { "ufffe" ,      132 } , //       0x84 -> UNDEFINED
      { "uf110" ,      133 } , //       0x85 -> FUNCTION KEY 1 
      { "uf112" ,      134 } , //       0x86 -> FUNCTION KEY 3 
      { "uf114" ,      135 } , //       0x87 -> FUNCTION KEY 5 
      { "uf116" ,      136 } , //       0x88 -> FUNCTION KEY 7 
      { "uf111" ,      137 } , //       0x89 -> FUNCTION KEY 2 
      { "uf113" ,      138 } , //       0x8A -> FUNCTION KEY 4 
      { "uf115" ,      139 } , //       0x8B -> FUNCTION KEY 6 

      { "uf117" ,      140 } , //       0x8C -> FUNCTION KEY 8 
      { "\n"    ,      141 } , //       0x8D -> LINE FEED
      { "u000f" ,      142 } , //       0x8E -> SHIFT IN
      { "ufffe" ,      143 } , //       0x8F -> UNDEFINED
      { "uf105" ,      144 } , //       0x90 -> BLACK 
      { "uf11e" ,      145 } , //       0x91 -> CURSOR UP 
      { "uf11b" ,      146 } , //       0x92 -> reverse OFF 
      { "u000c" ,      147 } , //       0x93 -> FORM FEED clear screen)
      { "uf121" ,      148 } , //       0x94 -> INSERT 
      { "uf106" ,      149 } , //       0x95 -> BROWN 

      { "uf107" ,      150 } , //       0x96 -> LIGHT red 
      { "uf108" ,      151 } , //       0x97 -> gray 1
      { "uf109" ,      152 } , //       0x98 -> GRAY 2 
      { "uf10a" ,      153 } , //       0x99 -> LIGHT GREEN 
      { "uf10b" ,      154 } , //       0x9A -> LIGHT BLUE 
      { "uf10c" ,      155 } , //       0x9B -> GRAY 3 
      { "uf10d" ,      156 } , //       0x9C -> PURPLE 
      { "uf11d" ,      157 } , //       0x9D -> CURSOR LEFT 
      { "uf10e" ,      158 } , //       0x9E -> YELLOW 
      { "uf10f" ,      159 } , //       0x9F -> CYAN 

      { "u00a0" ,      160 } , //       0xA0 -> NO-BREAK SPACE
      { "u258c" ,      161 } , //  ▌    0xA1 -> LEFT HALF BLOCK
      { "u2584" ,      162 } , //  ▄    0xA2 -> LOWER HALF BLOCK
      { "u2594" ,      163 } , //  ▔    0xA3 -> UPPER 1/8 BLOCK
      { "u2581" ,      164 } , //  ▁    0xA4 -> LOWER 1/8 BLOCK
      { "u258f" ,      165 } , //  ▏    0xA5 -> LEFT 1/8 BLOCK
      { "u2592" ,      166 } , //  ▒    0xA6 -> MEDIUM SHADE
      { "u2595" ,      167 } , //  ▕    0xA7 -> RIGHT 1/8 BLOCK
      { "uf12f" ,      168 } , //      0xA8 -> LOWER HALF BLOCK MEDIUM SHADE 
      { "u25e4" ,      169 } , //  ◤    0xA9 -> BLACK UPPER LEFT TRIANGLE

      { "uf130" ,      170 } , //      0xAA -> RIGHT 1/4 BLOCK 
      { "u251c" ,      171 } , //  ├    0xAB -> box LIGHT VERTICAL AND RIGHT
      { "u2597" ,      172 } , //  ▗    0xAC -> QUADRANT LOWER RIGHT
      { "u2514" ,      173 } , //  └    0xAD -> box LIGHT UP AND RIGHT
      { "u2510" ,      174 } , //  ┐    0xAE -> box LIGHT DOWN AND LEFT
      { "u2582" ,      175 } , //  ▂    0xAF -> LOWER 1/4 BLOCK
      { "u250c" ,      176 } , //  ┌    0xB0 -> box LIGHT DOWN AND RIGHT
      { "u2534" ,      177 } , //  ┴    0xB1 -> box LIGHT UP AND HORIZONTAL
      { "u252c" ,      178 } , //  ┬    0xB2 -> box LIGHT DOWN AND HORIZONTAL
      { "u2524" ,      179 } , //  ┤    0xB3 -> box LIGHT VERTICAL AND LEFT

      { "u258e" ,      180 } , //  ▎    0xB4 -> LEFT 1/4 BLOCK
      { "u258d" ,      181 } , //  ▍    0xB5 -> LEFT 3/8 BLOCK
      { "uf131" ,      182 } , //      0xB6 -> RIGHT 3/8 BLOCK 
      { "uf132" ,      183 } , //      0xB7 -> UPPER 1/4 BLOCK 
      { "uf133" ,      184 } , //      0xB8 -> UPPER 3/8 BLOCK 
      { "u2583" ,      185 } , //  ▃    0xB9 -> LOWER 3/8 BLOCK
      { "uf12d" ,      186 } , //      0xBA -> 1/8 BLOCK UP AND LEFT 
      { "u2596" ,      187 } , //  ▖    0xBB -> QUADRANT LOWER LEFT
      { "u259d" ,      188 } , //  ▝    0xBC -> QUADRANT UPPER RIGHT
      { "u2518" ,      189 } , //  ┘    0xBD -> box LIGHT UP AND LEFT

      { "u2598" ,      190 } , //  ▘    0xBE -> QUADRANT UPPER LEFT
      { "u259a" ,      191 } , //  ▚    0xBF -> QUADRANT UPPER LEFT AND LOWER RIGHT
      { "u2500" ,      192 } , //  ─    0xC0 -> box LIGHT HORIZONTAL
      { "u2660" ,      193 } , //  ♠    0xC1 -> BLACK SPADE SUIT
      { "uf13c" ,      194 } , //  │    0xC2 -> box LIGHT VERTICAL 1/8 LEFT 
      { "uf13b" ,      195 } , //  ─    0xC3 -> box LIGHT HORIZONTAL 1/8 UP 
      { "uf122" ,      196 } , //      0xC4 -> box LIGHT HORIZONTAL 2/8 UP 
      { "uf123" ,      197 } , //      0xC5 -> box LIGHT HORIZONTAL 3/8 UP 
      { "uf124" ,      198 } , //      0xC6 -> box LIGHT HORIZONTAL 1/8 DOWN 
      { "uf126" ,      199 } , //      0xC7 -> box LIGHT VERTICAL 2/8 LEFT 

      { "uf128" ,      200 } , //      0xC8 -> box LIGHT VERTICAL 1/8 RIGHT 
      { "u256e" ,      201 } , //  ╮    0xC9 -> box LIGHT ARC DOWN AND LEFT
      { "u2570" ,      202 } , //  ╰    0xCA -> box LIGHT ARC UP AND RIGHT
      { "u256f" ,      203 } , //  ╯    0xCB -> box LIGHT ARC UP AND LEFT
      { "uf12a" ,      204 } , //      0xCC -> 1/8 BLOCK UP AND RIGHT 
      { "u2572" ,      205 } , //  ╲    0xCD -> box LIGHT DIAGONAL UPPER LEFT TO LOWER RIGHT
      { "u2571" ,      206 } , //  ╱    0xCE -> box LIGHT DIAGONAL UPPER RIGHT TO LOWER LEFT
      { "uf12b" ,      207 } , //      0xCF -> 1/8 BLOCK DOWN AND RIGHT 
      { "uf12c" ,      208 } , //      0xD0 -> 1/8 BLOCK DOWN AND LEFT 
      { "u25cf" ,      209 } , //  ●    0xD1 -> BLACK CIRCLE

      { "uf125" ,      210 } , //      0xD2 -> box LIGHT HORIZONTAL 2/8 DOWN 
      { "u2665" ,      211 } , //  ♥    0xD3 -> BLACK HEART SUIT
      { "uf127" ,      212 } , //      0xD4 -> box LIGHT VERTICAL 3/8 LEFT 
      { "u256d" ,      213 } , //  ╭    0xD5 -> box LIGHT ARC DOWN AND LEFT
      { "u2573" ,      214 } , //  ╳    0xD6 -> box LIGHT DIAGONAL CROSS
      { "u25cb" ,      215 } , //  ○    0xD7 -> WHITE CIRCLE
      { "u2663" ,      216 } , //  ♣    0xD8 -> BLACK CLUB SUIT
      { "uf129" ,      217 } , //      0xD9 -> box LIGHT VERTICAL 2/8 RIGHT 
      { "u2666" ,      218 } , //  ♦    0xDA -> BLACK DIAMOND SUIT
      { "u253c" ,      219 } , //  ┼    0xDB -> box LIGHT VERTICAL AND HORIZONTAL

      { "uf12e" ,      220 } , //      0xDC -> LEFT HALF BLOCK MEDIUM SHADE 
      { "u2502" ,      221 } , //  │    0xDD -> box LIGHT VERTICAL
      { "u03c0" ,      222 } , //  π    0xDE -> pi
      { "u25e5" ,      223 } , //  ◥    0xDF -> BLACK UPPER RIGHT TRIANGLE
      { "u00a0" ,      224 } , //       0xE0 -> NO-BREAK SPACE
      { "u258c" ,      225 } , //  ▌    0xE1 -> LEFT HALF BLOCK
      { "u2584" ,      226 } , //  ▄    0xE2 -> LOWER HALF BLOCK
      { "u2594" ,      227 } , //  ▔    0xE3 -> UPPER 1/8 BLOCK
      { "u2581" ,      228 } , //  ▁    0xE4 -> LOWER 1/8 BLOCK
      { "u258f" ,      229 } , //  ▏    0xE5 -> LEFT 1/8 BLOCK

      { "u2592" ,      230 } , //  ▒    0xE6 -> MEDIUM SHADE
      { "u2595" ,      231 } , //  ▕    0xE7 -> RIGHT 1/8 BLOCK
      { "uf12f" ,      232 } , //      0xE8 -> LOWER HALF BLOCK MEDIUM SHADE 
      { "u25e4" ,      233 } , //  ◤    0xE9 -> BLACK UPPER LEFT TRIANGLE
      { "uf130" ,      234 } , //      0xEA -> RIGHT 1/4 BLOCK 
      { "u251c" ,      235 } , //  ├    0xEB -> box LIGHT VERTICAL AND RIGHT
      { "u2597" ,      236 } , //  ▗    0xEC -> QUADRANT LOWER RIGHT
      { "u2514" ,      237 } , //  └    0xED -> box LIGHT UP AND RIGHT
      { "u2510" ,      238 } , //  ┐    0xEE -> box LIGHT DOWN AND LEFT
      { "u2582" ,      239 } , //  ▂    0xEF -> LOWER 1/4 BLOCK

      { "u250c" ,      240 } , //  ┌    0xF0 -> box LIGHT DOWN AND RIGHT
      { "u2534" ,      241 } , //  ┴    0xF1 -> box LIGHT UP AND HORIZONTAL
      { "u252c" ,      242 } , //  ┬    0xF2 -> box LIGHT DOWN AND HORIZONTAL
      { "u2524" ,      243 } , //  ┤    0xF3 -> box LIGHT VERTICAL AND LEFT
      { "u258e" ,      244 } , //  ▎    0xF4 -> LEFT 1/4 BLOCK
      { "u258d" ,      245 } , //  ▍    0xF5 -> LEFT 3/8 BLOCK
      { "uf131" ,      246 } , //      0xF6 -> RIGHT 3/8 BLOCK 
      { "uf132" ,      247 } , //      0xF7 -> UPPER 1/4 BLOCK 
      { "uf133" ,      248 } , //      0xF8 -> UPPER 3/8 BLOCK 
      { "u2583" ,      249 } , //  ▃    0xF9 -> LOWER 3/8 BLOCK

      { "uf12d" ,      250 } , //      0xFA -> 1/8 BLOCK UP AND LEFT 
      { "u2596" ,      251 } , //  ▖    0xFB -> QUADRANT LOWER LEFT
      { "u259d" ,      252 } , //  ▝    0xFC -> QUADRANT UPPER RIGHT
      { "u2518" ,      253 } , //  ┘    0xFD -> box LIGHT UP AND LEFT
      { "u2598" ,      254 } , //  ▘    0xFE -> QUADRANT UPPER LEFT
      { "u03c0" ,      255 } , //  π    0xFF -> pi

} ;

std::map<std::string,unsigned char> c64PetsciiNamesUpperCase =
{
      { "u0000"                                 ,        0 } , //       0x00 -> \u0000
      { "undefined"                             ,        1 } , //       0x01 -> undefined
      { "undefined"                             ,        2 } , //       0x02 -> undefined
      { "undefined"                             ,        3 } , //       0x03 -> undefined
      { "undefined"                             ,        4 } , //       0x04 -> undefined
      { "white"                                 ,        5 } , //       0x05 -> white 
      { "undefined"                             ,        6 } , //       0x06 -> undefined
      { "undefined"                             ,        7 } , //       0x07 -> undefined
      { "disable character set switching"       ,        8 } , //       0x08 -> disable character set switching 
      { "enable character set switching"        ,        9 } , //       0x09 -> enable character set switching 

      { "undefined"                             ,       10 } , //       0x0a -> undefined
      { "undefined"                             ,       11 } , //       0x0b -> undefined
      { "undefined"                             ,       12 } , //       0x0c -> undefined
      { "\r"                                    ,       13 } , //       0x0d -> carriage return
      { "shift out"                             ,       14 } , //       0x0e -> shift out
      { "undefined"                             ,       15 } , //       0x0f -> undefined
      { "undefined"                             ,       16 } , //       0x10 -> undefined
      { "cursor down"                           ,       17 } , //       0x11 -> cursor down 
      { "reverse on"                            ,       18 } , //       0x12 -> reverse on 
      { "home"                                  ,       19 } , //       0x13 -> home 

      { "delete"                                ,       20 } , //       0x14 -> delete
      { "undefined"                             ,       21 } , //       0x15 -> undefined
      { "undefined"                             ,       22 } , //       0x16 -> undefined
      { "undefined"                             ,       23 } , //       0x17 -> undefined
      { "undefined"                             ,       24 } , //       0x18 -> undefined
      { "undefined"                             ,       25 } , //       0x19 -> undefined
      { "undefined"                             ,       26 } , //       0x1a -> undefined
      { "undefined"                             ,       27 } , //       0x1b -> undefined
      { "red"                   ,       28 } , //       0x1c -> red 
      { "cursor right"          ,       29 } , //       0x1d -> cursor right 

      { "green"                 ,       30 } , //       0x1e -> green 
      { "blue"                  ,       31 } , //       0x1f -> blue 
      { " "                     ,       32 } , //       0x20 -> space
      { "!"                     ,       33 } , //  !    0x21 -> !
      { "\""                    ,       34 } , //  "    0x22 -> "
      { "#"                     ,       35 } , //  #    0x23 -> #
      { "$"                     ,       36 } , //  $    0x24 -> $
      { "%"                     ,       37 } , //  %    0x25 -> %
      { "&"                     ,       38 } , //  &    0x26 -> &
      { "'"                     ,       39 } , //  '    0x27 -> '

      { "("                     ,       40 } , //  (    0x28 -> (
      { ")"                     ,       41 } , //  )    0x29 -> )
      { "*"                     ,       42 } , //  *    0x2a -> *
      { "+"                     ,       43 } , //  +    0x2b -> +
      { ","                     ,       44 } , //  ,    0x2c -> ,
      { "-"                     ,       45 } , //  -    0x2d -> -
      { "."                     ,       46 } , //  .    0x2e -> .
      { "/"                     ,       47 } , //  /    0x2f -> /
      { "0"                     ,       48 } , //  0    0x30 -> 0
      { "1"                     ,       49 } , //  1    0x31 -> 1

      { "2"                     ,       50 } , //  2    0x32 -> 2
      { "3"                     ,       51 } , //  3    0x33 -> 3
      { "4"                     ,       52 } , //  4    0x34 -> 4
      { "5"                     ,       53 } , //  5    0x35 -> 5
      { "6"                     ,       54 } , //  6    0x36 -> 6
      { "7"                     ,       55 } , //  7    0x37 -> 7
      { "8"                     ,       56 } , //  8    0x38 -> 8
      { "9"                     ,       57 } , //  9    0x39 -> 9
      { ":"                     ,       58 } , //  :    0x3a -> :
      { ";"                     ,       59 } , //  ;    0x3b -> ;

      { "<"                     ,       60 } , //  <    0x3c -> <
      { "="                     ,       61 } , //  =    0x3d -> =
      { ">"                     ,       62 } , //  >    0x3e -> >
      { "?"                     ,       63 } , //  ?    0x3f -> ?
      { "@"                     ,       64 } , //  @    0x40 -> commercial at

      { "A"                ,       65 } , //  a    0x41 -> latin capital letter a
      { "B"                ,       66 } , //  b    0x42 -> latin capital letter b
      { "C"                ,       67 } , //  c    0x43 -> latin capital letter c
      { "D"                ,       68 } , //  d    0x44 -> latin capital letter d
      { "E"                ,       69 } , //  e    0x45 -> latin capital letter e

      { "F"                ,       70 } , //  f    0x46 -> latin capital letter f
      { "G"                ,       71 } , //  g    0x47 -> latin capital letter g
      { "H"                ,       72 } , //  h    0x48 -> latin capital letter h
      { "I"                ,       73 } , //  i    0x49 -> latin capital letter i
      { "J"                ,       74 } , //  j    0x4a -> latin capital letter j
      { "K"                ,       75 } , //  k    0x4b -> latin capital letter k
      { "L"                ,       76 } , //  l    0x4c -> latin capital letter l
      { "M"                ,       77 } , //  m    0x4d -> latin capital letter m
      { "N"                ,       78 } , //  n    0x4e -> latin capital letter n
      { "O"                ,       79 } , //  o    0x4f -> latin capital letter o

      { "P"                ,       80 } , //  p    0x50 -> latin capital letter p
      { "Q"                ,       81 } , //  q    0x51 -> latin capital letter q
      { "R"                ,       82 } , //  r    0x52 -> latin capital letter r
      { "S"                ,       83 } , //  s    0x53 -> latin capital letter s
      { "T"                ,       84 } , //  t    0x54 -> latin capital letter t
      { "U"                ,       85 } , //  u    0x55 -> latin capital letter u
      { "V"                ,       86 } , //  v    0x56 -> latin capital letter v
      { "W"                ,       87 } , //  w    0x57 -> latin capital letter w
      { "X"                ,       88 } , //  x    0x58 -> latin capital letter x
      { "Y"                ,       89 } , //  y    0x59 -> latin capital letter y

      { "Z"                ,       90 } , //  z    0x5a -> latin capital letter z
      { "["                ,       91 } , //  [    0x5b -> [
      { "£"                ,       92 } , //  £    0x5c -> £
      { "]"                ,       93 } , //  ]    0x5d -> ]
      { "upwards arrow"             ,       94 } , //  ↑    0x5e -> upwards arrow
      { "leftwards arrow"           ,       95 } , //  ←    0x5f -> leftwards arrow
      { "box light horizontal"      ,       96 } , //  ─    0x60 -> box light horizontal
      { "black spade suit"          ,       97 } , //  ♠    0x61 -> black spade suit
      
      { "box light vertical 1/8 left"       ,       98 } , //  │    0x62 -> box light vertical 1/8 left 
      { "box light horizontal 1/8 up"       ,       99 } , //  ─    0x63 -> box light horizontal 1/8 up 

      { "box light horizontal 2/8 up"       ,      100 } , //      0x64 -> box light horizontal 2/8 up 
      { "box light horizontal 3/8 up"       ,      101 } , //      0x65 -> box light horizontal 3/8 up 
      { "box light horizontal 1/8 down "    ,      102 } , //      0x66 -> box light horizontal 1/8 down 
      { "box light vertical 2/8 left"       ,      103 } , //      0x67 -> box light vertical 2/8 left 
      { "box light vertical 1/8 right"      ,      104 } , //      0x68 -> box light vertical 1/8 right 
      { "box light arc down and left"       ,      105 } , //  ╮    0x69 -> box light arc down and left
      { "box light arc up and right"        ,      106 } , //  ╰    0x6a -> box light arc up and right
      { "box light arc up and left"         ,      107 } , //  ╯    0x6b -> box light arc up and left
      { "1/8 block up and right "                       ,      108 } , //      0x6c -> 1/8 block up and right 
      { "box light diagonal upper left to lower right"  ,      109 } , //  ╲    0x6d -> box light diagonal upper left to lower right

      { "box light diagonal upper right to lower left"  ,      110 } , //  ╱    0x6e -> box light diagonal upper right to lower left
      { "1/8 block down and right"                      ,      111 } , //      0x6f -> 1/8 block down and right 
      { "1/8 block down and left"                       ,      112 } , //      0x70 -> 1/8 block down and left 
      { "black circle"                                  ,      113 } , //  ●    0x71 -> black circle
      { "box light horizontal 2/8 down"                 ,      114 } , //      0x72 -> box light horizontal 2/8 down 
      { "black heart suit"                              ,      115 } , //  ♥    0x73 -> black heart suit
      { "box light vertical 3/8 left"                   ,      116 } , //      0x74 -> box light vertical 3/8 left 
      { "box light arc down and right"                  ,      117 } , //  ╭    0x75 -> box light arc down and right
      { "box light diagonal cross"                      ,      118 } , //  ╳    0x76 -> box light diagonal cross
      { "white circle"                                  ,      119 } , //  ○    0x77 -> white circle

      { "black club suit"                               ,      120 } , //  ♣    0x78 -> black club suit
      { "box light vertical 2/8 right"                  ,      121 } , //      0x79 -> box light vertical 2/8 right 
      { "black diamond suit"                            ,      122 } , //  ♦    0x7a -> black diamond suit
      { "box light vertical and horizontal"             ,      123 } , //  ┼    0x7b -> box light vertical and horizontal
      { "left half block medium shade"                  ,      124 } , //      0x7c -> left half block medium shade 
      { "box light vertical"                            ,      125 } , //  │    0x7d -> box light vertical
      { "pi"                                            ,      126 } , //  π    0x7e -> pi
      { "black upper right triangle"                    ,      127 } , //  ◥    0x7f -> black upper right triangle
      { "undefined"                                     ,      128 } , //       0x80 -> undefined
      { "orange"                                        ,      129 } , //      0x81 -> orange 

      { "undefined"                                 ,      130 } , //       0x82 -> undefined
      { "undefined"                                 ,      131 } , //       0x83 -> undefined
      { "undefined"                                 ,      132 } , //       0x84 -> undefined
      { "f1 "                           ,      133 } , //       0x85 -> function key 1 
      { "f3"                            ,      134 } , //       0x86 -> function key 3 
      { "f5"                            ,      135 } , //       0x87 -> function key 5 
      { "f7"                            ,      136 } , //       0x88 -> function key 7 
      { "f2"                            ,      137 } , //       0x89 -> function key 2 
      { "f4"                            ,      138 } , //       0x8a -> function key 4 
      { "f4"                            ,      139 } , //       0x8b -> function key 4 

      { "f4"                            ,      140 } , //       0x8c -> function key 4 
      
      { "\n"                                        ,      141 } , //       0x8d -> line feed
      { "hift in"                                   ,      142 } , //       0x8e -> shift in
      { "undefined"                                 ,      143 } , //       0x8f -> undefined
      { "black"                                     ,      144 } , //       0x90 -> black 
      { "cursor up"                                 ,      145 } , //       0x91 -> cursor up 
      { "reverse off"                               ,      146 } , //       0x92 -> reverse off 
      { "form feed clear screen)"                   ,      147 } , //       0x93 -> form feed clear screen)
      { "insert"                                    ,      148 } , //       0x94 -> insert 
      
      { "brown"                         ,      149 } , //       0x95 -> brown 

      { "light red"                     ,      150 } , //       0x96 -> light red 
      { "gray 1"                        ,      151 } , //       0x97 -> gray 1
      { "gray 2 "                       ,      152 } , //       0x98 -> gray 2 
      { "light green "                  ,      153 } , //       0x99 -> light green 
      { "light blue"                    ,      154 } , //       0x9a -> light blue 
      { "gray 3"                        ,      155 } , //       0x9b -> gray 3 
      { "purple"                        ,      156 } , //       0x9c -> purple 
      { "cursor left"                   ,      157 } , //       0x9d -> cursor left 
      { "yellow"                        ,      158 } , //       0x9e -> yellow 
      { "cyan"                          ,      159 } , //       0x9f -> cyan 

      { "no-break space"                         ,      160 } , //       0xa0 -> no-break space
      { "left half block"                        ,      161 } , //  ▌    0xa1 -> left half block
      { "lower half block"                       ,      162 } , //  ▄    0xa2 -> lower half block
      { "upper 1/8 block"                        ,      163 } , //  ▔    0xa3 -> upper 1/8 block
      { "lower 1/8 block"                        ,      164 } , //  ▁    0xa4 -> lower 1/8 block
      { "left 1/8 block"                         ,      165 } , //  ▏    0xa5 -> left 1/8 block
      { "medium shade"                           ,      166 } , //  ▒    0xa6 -> medium shade
      { "right 1/8 block"                        ,      167 } , //  ▕    0xa7 -> right 1/8 block
      { "lower half block medium shade "         ,      168 } , //      0xa8 -> lower half block medium shade 
      { "black upper left triangle"              ,      169 } , //  ◤    0xa9 -> black upper left triangle

      { "right 1/4 block"                        ,      170 } , //      0xaa -> right 1/4 block 
      { "box light vertical and right"           ,      171 } , //  ├    0xab -> box light vertical and right
      { "quadrant lower right"                   ,      172 } , //  ▗    0xac -> quadrant lower right
      { "box light up and right"                 ,      173 } , //  └    0xad -> box light up and right
      { "box light down and left"                ,      174 } , //  ┐    0xae -> box light down and left
      { "lower 1/4 block"                        ,      175 } , //  ▂    0xaf -> lower 1/4 block
      { "box light down and right"               ,      176 } , //  ┌    0xb0 -> box light down and right
      { "box light up and horizontal"            ,      177 } , //  ┴    0xb1 -> box light up and horizontal
      { "box light down and horizontal"          ,      178 } , //  ┬    0xb2 -> box light down and horizontal
      { "box light vertical and left"            ,      179 } , //  ┤    0xb3 -> box light vertical and left

      { "left 1/4 block"                         ,      180 } , //  ▎    0xb4 -> left 1/4 block
      { "left 3/8 block"                         ,      181 } , //  ▍    0xb5 -> left 3/8 block
      { "right 3/8 block"                        ,      182 } , //      0xb6 -> right 3/8 block 
      { "upper 1/4 block"                        ,      183 } , //      0xb7 -> upper 1/4 block 
      { "upper 3/8 block"                        ,      184 } , //      0xb8 -> upper 3/8 block 
      { "lower 3/8 block"                        ,      185 } , //  ▃    0xb9 -> lower 3/8 block
      { "1/8 block up and left"                  ,      186 } , //      0xba -> 1/8 block up and left 
      { "quadrant lower left"                    ,      187 } , //  ▖    0xbb -> quadrant lower left
      { "quadrant upper right"                   ,      188 } , //  ▝    0xbc -> quadrant upper right
      { "box light up and left"                  ,      189 } , //  ┘    0xbd -> box light up and left

      { "quadrant upper left"                    ,      190 } , //  ▘    0xbe -> quadrant upper left
      { "quadrant upper left and lower right"    ,      191 } , //  ▚    0xbf -> quadrant upper left and lower right
      { "box light horizontal"                   ,      192 } , //  ─    0xc0 -> box light horizontal
      { "black spade suit"                       ,      193 } , //  ♠    0xc1 -> black spade suit
      
      { "box light vertical 1/8 left"            ,      194 } , //  │    0xc2 -> box light vertical 1/8 left 
      { "box light horizontal 1/8 up"            ,      195 } , //  ─    0xc3 -> box light horizontal 1/8 up 
      { "box light horizontal 2/8 up"            ,      196 } , //      0xc4 -> box light horizontal 2/8 up 
      { "box light horizontal 3/8 up "           ,      197 } , //      0xc5 -> box light horizontal 3/8 up 
      { "box light horizontal 1/8 down"          ,      198 } , //      0xc6 -> box light horizontal 1/8 down 
      { "box light vertical 2/8 left"            ,      199 } , //      0xc7 -> box light vertical 2/8 left 

      { "box light vertical 1/8 right"           ,      200 } , //      0xc8 -> box light vertical 1/8 right 
      { "box light arc down and left"            ,      201 } , //  ╮    0xc9 -> box light arc down and left
      { "box light arc up and right"             ,      202 } , //  ╰    0xca -> box light arc up and right
      { "box light arc up and left"              ,      203 } , //  ╯    0xcb -> box light arc up and left
      { "1/8 block up and right"                 ,      204 } , //      0xcc -> 1/8 block up and right 
      { "box light diagonal upper left to lower right"  ,      205 } , //  ╲    0xcd -> box light diagonal upper left to lower right
      { "box light diagonal upper right to lower left"  ,      206 } , //  ╱    0xce -> box light diagonal upper right to lower left
      { "1/8 block down and right"                      ,      207 } , //      0xcf -> 1/8 block down and right 
      { "1/8 block down and left "                      ,      208 } , //      0xd0 -> 1/8 block down and left 
      { "black circle"                                  ,      209 } , //  ●    0xd1 -> black circle

      { "box light horizontal 2/8 down"                 ,      210 } , //      0xd2 -> box light horizontal 2/8 down 
      { "black heart suit"                              ,      211 } , //  ♥    0xd3 -> black heart suit
      { "box light vertical 3/8 left"                   ,      212 } , //      0xd4 -> box light vertical 3/8 left 
      { "box light arc down and left"                   ,      213 } , //  ╭    0xd5 -> box light arc down and left
      { "box light diagonal cross"                      ,      214 } , //  ╳    0xd6 -> box light diagonal cross
      { "white circle"                                  ,      215 } , //  ○    0xd7 -> white circle
      { "black club suit"                               ,      216 } , //  ♣    0xd8 -> black club suit
      { "box light vertical 2/8 right"                  ,      217 } , //      0xd9 -> box light vertical 2/8 right 
      { "black diamond suit"                            ,      218 } , //  ♦    0xda -> black diamond suit
      { "box light vertical and horizontal"             ,      219 } , //  ┼    0xdb -> box light vertical and horizontal

      { "left half block medium shade"                  ,      220 } , //      0xdc -> left half block medium shade 
      { "box light vertical"                            ,      221 } , //  │    0xdd -> box light vertical
      { "pi"                                            ,      222 } , //  π    0xde -> pi
      { "black upper right triangle"                    ,      223 } , //  ◥    0xdf -> black upper right triangle
      { "no-break space"                                ,      224 } , //       0xe0 -> no-break space
      { "left half block"                               ,      225 } , //  ▌    0xe1 -> left half block
      { "lower half block"                              ,      226 } , //  ▄    0xe2 -> lower half block
      { "upper 1/8 block"                               ,      227 } , //  ▔    0xe3 -> upper 1/8 block
      { "lower 1/8 block"                               ,      228 } , //  ▁    0xe4 -> lower 1/8 block
      { "left 1/8 block"                                ,      229 } , //  ▏    0xe5 -> left 1/8 block

      { "medium shade"                                  ,      230 } , //  ▒    0xe6 -> medium shade
      { "right 1/8 block"                               ,      231 } , //  ▕    0xe7 -> right 1/8 block
      { "lower half block medium shade "                ,      232 } , //      0xe8 -> lower half block medium shade 
      { "black upper left triangle"                     ,      233 } , //  ◤    0xe9 -> black upper left triangle
      { "right 1/4 block"                               ,      234 } , //      0xea -> right 1/4 block 
      { "box light vertical and right"                  ,      235 } , //  ├    0xeb -> box light vertical and right
      { "quadrant lower right"                          ,      236 } , //  ▗    0xec -> quadrant lower right
      { "box light up and right"                        ,      237 } , //  └    0xed -> box light up and right
      { "box light down and left"                       ,      238 } , //  ┐    0xee -> box light down and left
      { "lower 1/4 block"                               ,      239 } , //  ▂    0xef -> lower 1/4 block

      { "box light down and right"             ,      240 } , //  ┌    0xf0 -> box light down and right
      { "box light up and horizontal"          ,      241 } , //  ┴    0xf1 -> box light up and horizontal
      { "box light down and horizontal"        ,      242 } , //  ┬    0xf2 -> box light down and horizontal
      { "box light vertical and left"          ,      243 } , //  ┤    0xf3 -> box light vertical and left
      { "left 1/4 block"                       ,      244 } , //  ▎    0xf4 -> left 1/4 block
      { "left 3/8 block"                       ,      245 } , //  ▍    0xf5 -> left 3/8 block
      { "right 3/8 block"                      ,      246 } , //      0xf6 -> right 3/8 block 
      { "upper 1/4 block"                      ,      247 } , //      0xf7 -> upper 1/4 block 
      { "upper 3/8 block"                      ,      248 } , //      0xf8 -> upper 3/8 block 
      { "lower 3/8 block"                      ,      249 } , //  ▃    0xf9 -> lower 3/8 block

      { "1/8 block up and left"                ,      250 } , //      0xfa -> 1/8 block up and left 
      { "quadrant lower left"                  ,      251 } , //  ▖    0xfb -> quadrant lower left
      { "quadrant upper right"                 ,      252 } , //  ▝    0xfc -> quadrant upper right
      { "box light up and left"                ,      253 } , //  ┘    0xfd -> box light up and left
      { "quadrant upper left"                  ,      254 } , //  ▘    0xfe -> quadrant upper left
      { "pi"                                   ,      255 } , //  π    0xff -> pi

} ;

int c64TranslateScreenLowerChar( std::string s )        //  .......................... s
{
    std::string item = std::string(s);
    
    auto it1  = c64ScreenCodesLowerCase.find(item);
    if ( it1 != c64ScreenCodesLowerCase.end() )  return it1->second ;
    
    auto it2  = c64ScreenNamesLowerCase.find(item);
    if ( it2 != c64ScreenNamesLowerCase.end() )  return it2->second ;
    
    return -1 ;
}
int c64TranslateScreenUpperChar( std::string s )        //  .......................... S
{
    std::string item = std::string(s);
    
    auto it1  = c64ScreenCodesUpperCase.find(item);
    if ( it1 != c64ScreenCodesUpperCase.end() )  return it1->second+128 ;
    
    auto it2  = c64ScreenNamesUpperCase.find(item);
    if ( it2 != c64ScreenNamesUpperCase.end() )  return it2->second+128 ;
    
    return -1 ;
}
int c64TranslatePetsciiLowerChar( std::string s )        //  .......................... p
{
    std::string item = std::string(s);
    
    auto it1  = c64PetsciiCodesLowerCase.find(item);
    if ( it1 != c64PetsciiCodesLowerCase.end() )  return it1->second ;
    
    auto it2  = c64PetsciiNamesLowerCase.find(item);
    if ( it2 != c64PetsciiNamesLowerCase.end() )  return it2->second ;
    
    return -1 ;
}
int c64TranslatePetsciiUpperChar( std::string s )        //  .......................... P
{
    std::string item = std::string(s);
    
    auto it1  = c64PetsciiCodesUpperCase.find(item);
    if ( it1 != c64PetsciiCodesUpperCase.end() )  return it1->second ;
    
    auto it2  = c64PetsciiNamesUpperCase.find(item);
    if ( it2 != c64PetsciiNamesUpperCase.end() )  return it2->second ;
    
    return -1 ;
}

/*

int main ( int argc, char* argv[] ) 
{
    printf ("%s\n",&argv[1][0]);
 
    printf ("\nScreen Lower        :") ;
    int res1 = c64TranslateScreenLowerChar(std::string(argv[1])) ;
    printf ("[%03d]" ,res1 ) ;
 
    
    printf ("\nScreen Upper        :") ;
    int res2 = c64TranslateScreenUpperChar(std::string(argv[1])) ;
    printf ("[%03d]" ,res2 ) ;
 

    printf ("\nPetscii Lower       :") ;
    int res3 = c64TranslatePetsciiLowerChar(std::string(argv[1])) ;
    printf ("[%03d]" ,res3 ) ;
 
 
    printf ("\nPetscii Upper       :") ;
    int res4 = c64TranslatePetsciiUpperChar(std::string(argv[1])) ;
    printf ("[%03d]" ,res4 ) ;
 
    
    return 0 ;
}
*/













